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
        let sut = TweetTimeline.feedFromBundle()
        
        //There are seven nodes in the json, make sure there are seven tweets
        XCTAssert(sut.count == 7)
        
        //"SUT" stands for subject of unit tests
        testTweetsForFieldsWith(tweetArray: sut)
    }
    
    //Root node is a tweet that has replies and is not in reply to anything
    func testTweetThreadWhenUsingRootNodeReturnPropertTweets() {
        let tweetTimeline = TweetTimeline.feedFromBundle()
        
        //The second tweet is a root node
        let rootNode = tweetTimeline[1]
        
        let sut = TweetTimeline.getTweetThreadWith(selectedTweet: rootNode, timeline: tweetTimeline)
        
        //This thread should contain three replies, make sure they have the correct fields
        testTweetsForFieldsWith(tweetArray: sut)
        XCTAssert(sut.count == 3)
    }
    
    //Test for each method in timeline
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Helper methods
    
    private func testTweetsForFieldsWith(tweetArray: [Tweet]) {
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
