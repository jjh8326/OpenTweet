//
//  TweetTimeline.swift
//  OpenTweet
//
//  Created by Joe H on 10/7/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

class TweetTimeline {
    //Get data from JSON
    static func fetchFeedFromBundle() {
        var feed = [Tweet]()
        do {
            //Get the url of the json
            if let timelineJSONURL = Bundle.main.url(forResource: Constants.dataFileName, withExtension: Constants.dataFileType) {
                //Get data from the json
                let timelineData = try Data(contentsOf: timelineJSONURL)
                //Convert the json into a dictionary
                let feedDictionary: Dictionary = try JSONSerialization.jsonObject(with: timelineData, options:[]) as! [String: Array<Any>]
                
                if let timeline: Array = feedDictionary[Constants.dataFileName] {
                    //Get the user's feed
                    feed = getFeed(fromTimeline: timeline)
                } else {
                    print("No data in timeline")
                }
            } else {
                print("File does not exist!")
            }
        } catch {
          print(error.localizedDescription)
        }
        //Send a notification saying that the tweets are ready to be loaded on the view
        NotificationCenter.default.post(name: .bundleDataParsed, object: nil, userInfo: [Constants.tweetTimelineKey: feed])
    }
    
    static func fetchTweetThread(withSelectedTweet tweet: Tweet, timeline: [Tweet]) {
        var tweetThread = [Tweet]()
        if tweet.reply == "" {
            //If the tweet is a root tweet the get all the replies
            tweetThread = TweetTimeline.getTweetReplies(forRootTweetID: tweet.id, timeline: timeline)
        } else {
            //First tweet in the thread should be the selected tweet
            for i in 0..<timeline.count {
                //If the tweet is the tweet the selected tweet is replying to then add it to our tweet thread
                if timeline[i].id == tweet.reply {
                    tweetThread.append(timeline[i])
                }
            }
            let rootTweet = tweetThread[0]
            
            //Format the content so a user knows its a response to tweet below it
            let updatedRootContent = String(format: Constants.originalMessage, rootTweet.content)
            let updatedRootTweet = Tweet(id: rootTweet.id,
                                         author: rootTweet.author,
                                         content: updatedRootContent,
                                         avatarURL: rootTweet.avatarURL,
                                         date: rootTweet.date,
                                         viewDate: rootTweet.viewDate,
                                         reply: rootTweet.reply)
                
            tweetThread = [tweet, updatedRootTweet]
        }
        
        //Send a notification saying that the tweets are ready to be loaded with the tweet thread
        NotificationCenter.default.post(name: .tweetThreadCreated, object: nil, userInfo: [Constants.tweetThreadKey: tweetThread])
    }
    
    //Private methods
    
    //Get the tweet's replies
    private static func getTweetReplies(forRootTweetID id: String, timeline: [Tweet]) -> [Tweet] {
        //Store our replies in a dictionary with a key of the date
        //NOTE: Assume all our dates are unique, if this were a prod environment we could store micro seconds in the json or use some other identifer to sort the tweets
        var tweetReplies = [String: Tweet]()
        var tweetReplyDates = [String]()
        var sortedTweetReplies = [Tweet]()
        
        //Loop through the timeline and add all non root nodes that have a reply value set to the rootTweetID
        for i in 0..<timeline.count {
            let tweet = timeline[i]
            if (tweet.reply == id) {
                //If the reply ID is the root ID then add it to the replies
                tweetReplies[tweet.date] = tweet
                tweetReplyDates.append(tweet.date)
            }
        }
        
        //Sort our dates
        tweetReplyDates.sort()
        
        //Go through our sorted reply dates and add the tweets to the sorted tweets array
        for i in 0..<tweetReplyDates.count {
            //Add the tweets in reversed order so the newest replies appear first
            if let reply = tweetReplies[tweetReplyDates[tweetReplyDates.count - 1 - i]] {
                sortedTweetReplies.append(reply)
            }
        }
        
        //If there are no tweets and the tweet is not a reply then the cell will say there is no reply
        if sortedTweetReplies.count == 0 {
            sortedTweetReplies.append(Tweet(id: "",
                                            author: "",
                                            content: Constants.noRepliesMessage,
                                            avatarURL: "",
                                            date: "",
                                            viewDate: "",
                                            reply: ""))
        }
        
        return sortedTweetReplies
    }
    
    private static func getFeed(fromTimeline timeline: [Any]) -> [Tweet] {
        var feed = [Tweet]()
        //Create a tweet from each array in the dictionary
        for i in 0..<timeline.count {
            let dict: Dictionary = timeline[i] as! [String: String]
            //Assuming it's standard for all the user names to start with @, remove the @ symbol to better match actual twitter
            var username = ""
            if let authorValue = dict[Constants.authorKey] {
                username = authorValue
                //Remove the @ symbol in the author of the tweet
                username.removeFirst()
            }
            
            //Get the data from the dictionary and create a tweet
            let tweet = Tweet(
                id: dict[Constants.idKey] ?? "",
                author: username,
                content: dict[Constants.contentKey] ?? "",
                avatarURL: dict[Constants.avatarKey] ?? "",
                date: dict[Constants.dateKey] ?? "",
                viewDate: createViewDate(withTweetDate: dict[Constants.dateKey] ?? ""),
                reply: dict[Constants.inReplyToKey] ?? "")
            feed.append(tweet)
        }
        return feed
    }

    //Format the date for the required date time format
    private static func createViewDate(withTweetDate dateString: String) -> String {
        //The date that is in the json is an ISO date
        let isoDateFormatter = DateFormatter()
        //Set the locale to the user's locale
        isoDateFormatter.locale = Locale.current
        //Set the formatter to the ISO format
        isoDateFormatter.dateFormat = Constants.isoDateFormatString
        
        //Create the date if it's valid
        if let date = isoDateFormatter.date(from: dateString) {
            //If you want to make sure I accomplished the original requirement, this will output a non twitter-esque date
            let requiredDateFormatter = DateFormatter()
            requiredDateFormatter.dateFormat = Constants.requiredDateFormatString
            return requiredDateFormatter.string(from: date)
        }
        //TODO: Error logging class
        print("Failed to format date!")
        //If for whatever reason the date failed to format then return the original date
        return dateString
    }
}
