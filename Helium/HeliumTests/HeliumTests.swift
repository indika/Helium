//
//  HeliumTests.swift
//  HeliumTests
//
//  Created by Jaden Geller on 4/9/15.
//  Copyright (c) 2015 Jaden Geller. All rights reserved.
//
// swiftlint:disable line_length

import Cocoa
import XCTest

class MagicTests: XCTestCase {
  static func t(_ stringURL: String) -> String? {
    if let afterUrl = UrlHelpers.doMagic(stringURL: stringURL) {
      return afterUrl.absoluteString
    } else {
      return nil
    }
  }

  func testYoutube() {
    XCTAssertEqual(MagicTests.t("https://youtu.be"), nil)
    XCTAssertEqual(MagicTests.t("https://youtu.be/5z887j6gBr4"), "https://youtube.com/embed/5z887j6gBr4")
    XCTAssertEqual(MagicTests.t("youtu.be/xWcldHxHFpo&t=3h6m9s"), "https://youtube.com/embed/xWcldHxHFpo?start=11169")
    XCTAssertEqual(MagicTests.t("https://www.youtube.com/watch?v=q6EoRBvdVPQ?t=4"), "https://youtube.com/embed/q6EoRBvdVPQ?start=4")
  }

  func testTwitch() {
    XCTAssertEqual(MagicTests.t("https://twitch.tv/"), nil)
    XCTAssertEqual(MagicTests.t("https://twitch.tv/p/about"), nil)
    XCTAssertEqual(MagicTests.t("http://twitch.tv/playbattlegrounds"), "https://player.twitch.tv?html5&channel=playbattlegrounds")
    XCTAssertEqual(MagicTests.t("https://www.twitch.tv/videos/140064610"), "https://player.twitch.tv?html5&video=v140064610")
  }

  func testVimeo() {
    XCTAssertEqual(MagicTests.t("vimeo.com"), nil)
    XCTAssertEqual(MagicTests.t("https://vimeo.com/armanddijcks"), nil)
    XCTAssertEqual(MagicTests.t("vimeo.com/215405296"), "https://player.vimeo.com/video/215405296")
  }
}

class HelpersTest: XCTestCase {
  func testValidate() {
    XCTAssertEqual(UrlHelpers.isValid(urlString: "njknfs"), false)
    XCTAssertEqual(UrlHelpers.isValid(urlString: ""), false)
    XCTAssertEqual(UrlHelpers.isValid(urlString: "http://"), false)
    XCTAssertEqual(UrlHelpers.isValid(urlString: "http://example.com"), true)
    XCTAssertEqual(UrlHelpers.isValid(urlString: "https://note.it/?q=Spaces NOT escaped"), false)
  }
}
