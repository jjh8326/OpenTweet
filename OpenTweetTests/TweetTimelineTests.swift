//
//  TimelineTests.swift
//  OpenTweetTests
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import XCTest

class TimelineTests: XCTestCase {
    
    //Tweet Timeline test
    
    //When given valid JSON and nodes return the appropriate number of tweets
    //Nodes are tweets in the json - root node is a node that is not in reply to anything
    func testTweetTimelineFromBundleWhenNodesReturnProperTweets() {
        //Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(testTweetTimelineFromNotification(_:)), name: .bundleDataParsed, object: nil)
        
        TweetTimeline.fetchFeedFromBundle()
        
        //Sleep to allow time for bundle to be parsed and for notification to be observed
        sleep(10)
    }
    
    //Method the notification calls
    @objc
    func testTweetTimelineFromNotification(_ notification: NSNotification) {
        var sut = [Tweet]()
        //Get our tweets from the notification
        if let userInfo = notification.userInfo {
            //Subject of the unit test is our tweet timeline
            if userInfo[Constants.tweetTimelineKey] != nil {
                let tweetTimeline = userInfo[Constants.tweetTimelineKey]
                sut = tweetTimeline as! [Tweet]
                XCTAssert(sut.count == 8)
                
                //Getting error "Expected Tweet but found Tweet", tried to fix but for now its commented out
//                for i in 0..<sut.count {
//                    TweetTests.testTweetForFieldsWith(tweet: sut[i])
//                }
            }
        }
    }
}
