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
        
        TweetTests.testTweetsForFieldsWith(tweetArray: [sut])
    }
    
    //This is a flimsy test but it's used to add code coverage
    func testCreatingANewTweetWithNoData() {
        //Create a blank tweet
        let sut = Tweet()
        //Make sure the tweet is blank
        XCTAssertTrue(sut.id == "")
    }
    
    //Helper methods
    
    static func testTweetsForFieldsWith(tweetArray: [Tweet]) {
        //Test to make sure all the tweets that were created are valid
        for i in 0..<tweetArray.count {
            let sut = tweetArray[i]
            //Each tweet must have an id, author, content, date, view date
            XCTAssert(sut.id != "")
            XCTAssert(sut.author != "")
            XCTAssert(sut.content != "")
            XCTAssert(sut.date != "")
            XCTAssert(sut.viewDate != "")
        }
    }
}
