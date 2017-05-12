//
//  ViewController.swift
//  Helium
//
//  Created by Jaden Geller on 4/9/15.
//  Copyright (c) 2015 Jaden Geller. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKNavigationDelegate {

  var trackingTag: NSTrackingRectTag?

  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(WebViewController.loadURL(urlObject:)),
      name: NSNotification.Name(rawValue: "HeliumLoadURLString"),
      object: nil)

    // Layout webview
    view.addSubview(webView)
    webView.frame = view.bounds
    webView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable]

    // Allow plug-ins such as silverlight
    webView.configuration.preferences.plugInsEnabled = true

    // Custom user agent string for Netflix HTML5 support
    // swiftlint:disable:next line_length
    webView._customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/601.6.17 (KHTML, like Gecko) Version/9.1.1 Safari/601.6.17"

    // Setup magic URLs
    webView.navigationDelegate = self

    // Allow zooming
    webView.allowsMagnification = true

    // Alow back and forth
    webView.allowsBackForwardNavigationGestures = true

    // Listen for load progress
    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

    clear()
  }

  override func viewDidLayout() {
    super.viewDidLayout()

    if let tag = trackingTag {
      view.removeTrackingRect(tag)
    }

    trackingTag = view.addTrackingRect(view.bounds, owner: self, userData: nil, assumeInside: false)
  }

  // MARK: Actions
  override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    switch menuItem.title {
    case "Back":
      return webView.canGoBack
    case "Forward":
      return webView.canGoForward
    default:
      return true
    }
  }

  @IBAction func backPress(_ sender: AnyObject) {
    webView.goBack()
  }

  @IBAction func forwardPress(_ sender: AnyObject) {
    webView.goForward()
  }

  fileprivate func zoomIn() {
    webView.magnification += 0.1
  }

  fileprivate func zoomOut() {
    webView.magnification -= 0.1
  }

  fileprivate func resetZoom() {
    webView.magnification = 1
  }

  @IBAction fileprivate func reloadPress(_ sender: AnyObject) {
    requestedReload()
  }

  @IBAction fileprivate func clearPress(_ sender: AnyObject) {
    clear()
  }

  @IBAction fileprivate func resetZoomLevel(_ sender: AnyObject) {
    resetZoom()
  }
  @IBAction fileprivate func zoomIn(_ sender: AnyObject) {
    zoomIn()
  }
  @IBAction fileprivate func zoomOut(_ sender: AnyObject) {
    zoomOut()
  }

  // MARK: - URL management
  internal var currentURL: String? {
    return webView.url?.absoluteString
  }

  internal func loadURL(text: String) {
    let text = UrlHelpers.ensureScheme(text)
    if let url = URL(string: text) {
      loadURL(url: url)
    }
  }

  internal func loadURL(url: URL) {
    webView.load(URLRequest(url: url))
  }

  func loadURL(urlObject: Notification) {
    if let string = urlObject.object as? String {
      loadURL(text: string)
    }
  }

  fileprivate func requestedReload() {
    webView.reload()
  }

  // MARK: Webview functions
  /// Reload to home page (or default if no URL stored in UserDefaults)
  func clear() {
    loadURL(text: UserSettings.homePageURL.value)
  }

  var webView = WKWebView()

  // MARK: - Redirect magic urls
  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard !UserSettings.disabledMagicURLs.value,
      let url = navigationAction.request.url else {
        decisionHandler(WKNavigationActionPolicy.allow)
        return
    }

    if let newUrl = UrlHelpers.doMagic(url) {
      decisionHandler(WKNavigationActionPolicy.cancel)
      loadURL(url: newUrl)
    } else {
      decisionHandler(WKNavigationActionPolicy.allow)
    }
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
    if let pageTitle = webView.title {
      var title = pageTitle
      if title.isEmpty { title = "Helium" }
      let notif = Notification(name: Notification.Name(rawValue: "HeliumUpdateTitle"), object: title)
      NotificationCenter.default.post(notif)
    }
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?) {

    if keyPath == "estimatedProgress",
      let view = object as? WKWebView, view == webView {
      if let progress = change?[NSKeyValueChangeKey(rawValue: "new")] as? Float {
        let percent = progress * 100
        var title = NSString(format: "Loading... %.2f%%", percent)
        if percent == 100 {
          title = "Helium"
        }

        let notif = Notification(name: Notification.Name(rawValue: "HeliumUpdateTitle"), object: title)
        NotificationCenter.default.post(notif)
      }
    }
  }
}
