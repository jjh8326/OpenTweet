//
//  TweetTests.swift
//  OpenTweetTests
//
//  Created by Joe H on 10/13/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import XCTest

class TweetTests: XCTestCase {
    func testCreatingANewTweetWithValidData() {
        let sut = Tweet(id: "0023", author: "guy-who-wants-a-job", content: "Test tweet.", avatarURL: "", date: "2019-10-12T10:03:00-09:00", viewDate: "2y", reply: "")
        
        TweetTests.testTweetForFieldsWith(tweet: sut)
    }
    
    //This is a flimsy test but it's used to add code coverage
    func testCreatingANewTweetWithNoData() {
        //Create a blank tweet
        let sut = Tweet()
        //Make sure the tweet is blank
        XCTAssertTrue(sut.id == "")
    }
    
    //Helper methods
    
    static func testTweetForFieldsWith(tweet: Tweet) {
        //Test to make that the tweet is valid
        XCTAssert(tweet.id != "")
        XCTAssert(tweet.author != "")
        XCTAssert(tweet.content != "")
        XCTAssert(tweet.date != "")
        XCTAssert(tweet.viewDate != "")
    }
}
