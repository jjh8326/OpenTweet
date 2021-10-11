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
    let date: String
}

//NOTE: Normally I do not commit this but I wanted to give you a little insight into how my brain works when coding. Often when I code I make notes on how I would solve a problem, below are my (cleaned up) notes on how I would load a tweet's replies

//TODO: Algorithm to optimally sort and store tweet replies, the VC will pass on the root tweet, we just need to get the replies

//To accomplish this:
//Create a dictionary - [ ROOT ID: [REPLIES] ]
//Sort the replies

//Steps
//1. Loop through the timeline and add all root tweets IDs as a key to a dictionary and create the above data structure
//2. Loop through the timeline again and this time add all non root nodes (nodes with the "inReplyTo" field) to the value of the dictionary which is a array of tweets
//NOTE: It would be nice to not have to loop through the timeline twice but we have to because a root node is not guaranteed to be before a reply node
//3. Sort the reply array in each dictionary (created in step 1), sort the tweets by the time interval between the root and reply
//5. You now have a sorted tweet reply structure :D

class Tweets {
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
    
    private static func getFeedFrom(_ timeline: [Any]) -> [Tweet] {
        var feed = [Tweet]()
        //Create a tweet from each array in the dictionary
        for i in 0..<timeline.count {
            let dict: Dictionary = timeline[i] as! [String: String]
            //Assuming it's standard for all the user names to start with @, lets remove the @ symbol
            var username = ""
            if let authorValue = dict[authorKey] {
                //TODO: Fix warning here
                username = authorValue.substring(from: authorValue.index(authorValue.startIndex, offsetBy: 1))
            }
            
            //Get the data from the dictionary and create a tweet
            let tweet = Tweet(id: dict[idKey] ?? "", author: username, content: dict[contentKey] ?? "", avatarURL: dict[avatarKey] ?? "", date: createTwitterLikeDate(dict[dateKey] ?? ""))
            feed.append(tweet)
        }
        return feed
    }

    //TODO: Create some unit tests here
    
    //In order to better match the twitter look this code is going to return how many years, days or hours the tweet was posted
    private static func createTwitterLikeDate(_ tweetDate: String) -> String {
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
