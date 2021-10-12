//
//  TimelineTests.swift
//  OpenTweetTests
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import XCTest

class TimelineTests: XCTestCase {
    
    //When given valid JSON and nodes return the appropriate number of tweets
    //Nodes are tweets in the json
    func testFeedFromBundleWhenNodesReturnProperTweets() {
        //Get our tweets from the bundle
        let tweets = Timeline.feedFromBundle()
        
        //There are seven nodes in the json, make sure there are seven tweets
        XCTAssert(tweets.count == 7)
        
        //Test to make sure all the tweets that were created are valid
        for i in 0..<tweets.count {
            let sut = tweets[i]
            //Each tweet must have an id, author, content, date, view date
            XCTAssert(sut.id != "")
            XCTAssert(sut.author != "")
            XCTAssert(sut.content != "")
            XCTAssert(sut.date != "")
            XCTAssert(sut.viewDate != "")
        }
    }
    
    //Test for each method in timeline
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
