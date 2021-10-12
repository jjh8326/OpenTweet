//
//  Timeline.swift
//  OpenTweet
//
//  Created by Joe H on 10/7/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Tweet {
    let id: String
    let author: String
    let content: String
    let avatarURL: String
    //Store JSON's date for future sorting
    let date: String
    //Store the formatted date for view presentation
    let viewDate: String
    let reply: String
}

class Timeline {
    //Get data from JSON
    static func feedFromBundle() -> [Tweet] {
        var feed = [Tweet]()
        do {
            //Get the url of the json
            if let timelineJSONURL = Bundle.main.url(forResource: timelineFileName, withExtension: timelineFileType) {
                //Get data from the json
                let timelineData = try Data(contentsOf: timelineJSONURL)
                //Convert the json into a dictionary
                let feedDictionary: Dictionary = try JSONSerialization.jsonObject(with: timelineData, options:[]) as! [String: Array<Any>]
                
                //If the timeline is empty return
                guard let timeline: Array = feedDictionary[timelineFileName] else {
                    print("No data in timeline")
                    return []
                }

                //Get the user's feed
                feed = getFeedFrom(timeline)
            } else {
                print("File does not exist!")
            }
        } catch {
          print(error.localizedDescription)
        }
        //Send a notification saying that the tweets are ready to be loaded
        NotificationCenter.default.post(name: .timelineDataParsed, object: nil, userInfo: nil)
        //Return the array of tweets
        return feed
    }
    
    //Get the tweet's replies
    static func getTweetRepliesFor(rootTweetID: String, timeline: [Tweet]) -> [Tweet] {
        //Store our replies in a dictionary with a key of the date
        //NOTE: Assume all our dates are unique, if this were a prod environment we could store micro seconds
        var tweetReplies = [String: Tweet]()
        var tweetReplyDates = [String]()
        var sortedTweetReplies = [Tweet]()
        
        //Loop through the timeline and add all non root nodes that have a reply value set to the rootTweetID
        for i in 0..<timeline.count {
            let tweet = timeline[i]
            if (tweet.reply == rootTweetID) {
                //If the reply ID is the root ID then add it to the replies
                tweetReplies[tweet.date] = tweet
                tweetReplyDates.append(tweet.date)
            }
        }
        
        //Sort our dates
        tweetReplyDates.sort()
        
        //Go through our sorted reply dates and add the tweets to the sorted tweets array in order
        for i in 0..<tweetReplyDates.count {
            if let reply = tweetReplies[tweetReplyDates[i]] {
                sortedTweetReplies.append(reply)
            }
        }
        
        //TODO: MAKE SURE THIS WORKS, new tweets should be first in replies
        
        NotificationCenter.default.post(name: .tweetThreadCreated, object: nil, userInfo: nil)
        
        //If there are no tweets then display a "fake" tweet saying there is no content
        //TODO: Consider displaying just the original tweet
        if sortedTweetReplies.count == 0 {
            sortedTweetReplies.append(Tweet(id: "", author: "", content: "There are no replies.", avatarURL: "", date: "", viewDate: "", reply: ""))
        }
        
        return sortedTweetReplies
    }
    
    //Private methods
    
    //TODO: Better method name here
    private static func getFeedFrom(_ timeline: [Any]) -> [Tweet] {
        var feed = [Tweet]()
        //Create a tweet from each array in the dictionary
        for i in 0..<timeline.count {
            let dict: Dictionary = timeline[i] as! [String: String]
            //Assuming it's standard for all the user names to start with @, remove the @ symbol to better match actual twitter
            var username = ""
            if let authorValue = dict[authorKey] {
                //TODO: Fix warning here
                username = authorValue.substring(from: authorValue.index(authorValue.startIndex, offsetBy: 1))
            }
            
            //Get the data from the dictionary and create a tweet
            let tweet = Tweet(id: dict[idKey] ?? "", author: username, content: dict[contentKey] ?? "", avatarURL: dict[avatarKey] ?? "", date: dict[dateKey] ?? "", viewDate: createViewDate(dict[dateKey] ?? ""), reply: dict[inReplyToKey] ?? "")
            feed.append(tweet)
        }
        return feed
    }

    //TODO: Create some unit tests here
    
    //In order to better match the twitter look this code is going to return how many years, days or hours the tweet was posted
    private static func createViewDate(_ tweetDate: String) -> String {
        //The date that is in the json is an ISO date
        let isoDateFormatter = DateFormatter()
        //Set the locale to the user's locale
        isoDateFormatter.locale = Locale.current
        //Set the formatter to the ISO format
        isoDateFormatter.dateFormat = isoDateFormatString
        var formattedDateString: String = ""
        
        //Create the date if it's valid
        if let date = isoDateFormatter.date(from: tweetDate) {
            let diffComponents = Calendar.current.dateComponents([.year,.month,.day,.hour], from: date, to: Date())
            //Get the years, months, days and hours passed since the tweet was posted
            if let years = diffComponents.year, let months = diffComponents.month, let days = diffComponents.day, let hours = diffComponents.hour {
                
                //If the year is greater than 0 use years to report tweet date, etc, default to hours if the tweet is less than a day old
                if (years > 0) {
                    formattedDateString = String(format: "%iy", years)
                } else if (months > 0) {
                    formattedDateString = String(format: "%im", months)
                } else if (days > 0){
                    formattedDateString = String(format: "%id", days)
                } else {
                    formattedDateString = String(format: "%ih", hours)
                }
            }
        }
        return formattedDateString
    }
}
