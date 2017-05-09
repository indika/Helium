//
//  HeliumTests.swift
//  HeliumTests
//
//  Created by Jaden Geller on 4/9/15.
//  Copyright (c) 2015 Jaden Geller. All rights reserved.
//

import Cocoa
import XCTest

func TestMagic (_ stringURL: String) -> String? {
	if let afterUrl = UrlHelpers.doMagic(stringURL: stringURL) {
		return afterUrl.absoluteString
	}
	else { return nil }
}

class HeliumTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testYoutube() {
		XCTAssertEqual(TestMagic("https://youtu.be"), nil)
		XCTAssertEqual(TestMagic("https://youtu.be/5z887j6gBr4"), "https://youtube.com/embed/5z887j6gBr4")
		XCTAssertEqual(TestMagic("youtu.be/xWcldHxHFpo&t=3h6m9s"), "https://youtube.com/embed/xWcldHxHFpo?start=11169")
		XCTAssertEqual(TestMagic("https://www.youtube.com/watch?v=q6EoRBvdVPQ?t=4"), "https://youtube.com/embed/q6EoRBvdVPQ?start=4")
    }

	func testTwitch() {
		XCTAssertEqual(TestMagic("https://twitch.tv/"), nil)
		XCTAssertEqual(TestMagic("https://twitch.tv/p/about"), nil)
		XCTAssertEqual(TestMagic("http://twitch.tv/playbattlegrounds"), "https://player.twitch.tv?html5&channel=playbattlegrounds")
		XCTAssertEqual(TestMagic("https://www.twitch.tv/videos/140064610"), "https://player.twitch.tv?html5&video=v140064610")
	}

	func testVimeo() {
		XCTAssertEqual(TestMagic("vimeo.com"), nil)
		XCTAssertEqual(TestMagic("https://vimeo.com/armanddijcks"), nil)
		XCTAssertEqual(TestMagic("vimeo.com/215405296"), "https://player.vimeo.com/video/215405296")
	}
}
