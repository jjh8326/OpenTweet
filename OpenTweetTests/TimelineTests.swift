//
//  TimelineTests.swift
//  OpenTweetTests
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import XCTest

class TimelineTests: XCTestCase {
    
    var tweetTimeline: [Tweet]!
    
    //When given valid JSON and nodes return the appropriate number of tweets
    //Nodes are tweets in the json
    func testFeedFromBundleWhenNodesReturnProperTweets() {
        //Get our tweets from the bundle
        let sut = TweetTimeline.feedFromBundle()
        
        //There are seven nodes in the json, make sure there are seven tweets
        //Note: I added a node for better code coverage (testing my date code)
        XCTAssert(sut.count == 8)
        
        //"SUT" stands for subject of unit tests
        TweetTests.testTweetsForFieldsWith(tweetArray: sut)
    }
    
    //Root node is a tweet that has replies and is not in reply to anything
    func testTweetThreadWhenUsingRootNodeReturnProperTweets() {
        //The second tweet is a root node
        let rootNode = tweetTimeline[1]
        
        let sut = TweetTimeline.getTweetThreadWith(selectedTweet: rootNode, timeline: tweetTimeline)
        
        //Each thread with a root node as the selected tweet should return the correct number of replies it has, this thread should contain three replies, make sure they have the correct fields
        TweetTests.testTweetsForFieldsWith(tweetArray: sut)
        XCTAssert(sut.count == 3)
    }
    
    //A reply node is a tweet that is a reply to another tweet
    func testTweetThreadWhenUsingReplyNodeReturnProperTweets() {
        let tweetTimeline = TweetTimeline.feedFromBundle()
        
        //The third tweet is a reply node
        let replyNode = tweetTimeline[2]
        
        let sut = TweetTimeline.getTweetThreadWith(selectedTweet: replyNode, timeline: tweetTimeline)
        
        //Each thread with a reply node as the selected tweet should return two tweets, the reply tweet itself and the tweet it was replying to
        TweetTests.testTweetsForFieldsWith(tweetArray: sut)
        XCTAssert(sut.count == 2)
    }
    
    func testTweetThreadWhenUsingRootNodeWithNoRepliesReturnProperTweets() {
        let tweetTimeline = TweetTimeline.feedFromBundle()
        
        //The first tweet is a root node with no replies
        let rootNode = tweetTimeline[0]
        
        let sut = TweetTimeline.getTweetThreadWith(selectedTweet: rootNode, timeline: tweetTimeline)
        
        //Each thread with a root node as the selected tweet should return the correct number of replies it has, this particular tweet has no replies so the only content that will display is the no replies message, this is contained in an empty tweet
        XCTAssert(sut.count == 1)
    }
    
    override func setUpWithError() throws {
        tweetTimeline = TweetTimeline.feedFromBundle()
    }
}
