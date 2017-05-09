//
//  AppDelegate.swift
//  Helium
//
//  Created by Jaden Geller on 4/9/15.
//  Copyright (c) 2015 Jaden Geller. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var magicURLMenu: NSMenuItem!
    @IBOutlet weak var percentageMenu: NSMenuItem!
    @IBOutlet weak var fullScreenFloatMenu: NSMenuItem!

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(AppDelegate.handleURLEvent(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        magicURLMenu.state = UserSettings.disabledMagicURLs.value ? NSOffState : NSOnState

        fullScreenFloatMenu.state = UserSettings.disabledFullScreenFloat.value ? NSOffState : NSOnState

		let alpha = UserSettings.opacityPercentage.value
        let offset = alpha/10 - 1
        for (index, button) in percentageMenu.submenu!.items.enumerated() {
            (button).state = (offset == index) ? NSOnState : NSOffState
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func magicURLRedirectToggled(_ sender: NSMenuItem) {
        sender.state = (sender.state == NSOnState) ? NSOffState : NSOnState
        UserSettings.disabledMagicURLs.value = (sender.state == NSOffState)
    }

    // MARK: - handleURLEvent
    // Called when the App opened via URL.
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {

        guard let keyDirectObject = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)),
            let urlString = keyDirectObject.stringValue else {
                return print("Can't get URL from event")
        }

        // skip 'helium://'
        let index = urlString.index(urlString.startIndex, offsetBy: 9)
        let url = urlString.substring(from: index)

        guard let urlObject = URL(string: url) else {
            return print("No valid URL to handle")
        }

        NotificationCenter.default.post(name: Notification.Name(rawValue: "HeliumLoadURL"), object: urlObject)
    }
}
