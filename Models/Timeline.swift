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
    let avatar: String
    let date: String
}

//TOOD: Put target back

class Tweets {
    // Get data from JSON
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
                
                //Create a tweet from each array in the dictionary
                for i in 0..<timeline.count {
                    let dict: Dictionary = timeline[i] as! [String: String]
                    //Get the data from the dictionary and create a tweet
                    
                    var formattedDateString: String = ""
                    //Get the date from the json, its in ISO format
                    let isoDate = dict[dateKey] ?? ""
                    let isoDateFormatter = DateFormatter()
                    //Set the locale to the user's locale
                    isoDateFormatter.locale = Locale.current
                    //Set the formatter to the ISO format
                    isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        
                    //Create the date if its valid
                    if let date = isoDateFormatter.date(from: isoDate) {
                        let customDateFormatter = DateFormatter()
                        //Set the date format to the date that we want
                        customDateFormatter.dateFormat = "yyyy-MM-dd"
                        //Set our formatted date
                        formattedDateString = customDateFormatter.string(from: date)
                    }
                    
                    let tweet = Tweet(id: dict[idKey] ?? "", author: dict[authorKey] ?? "", content: dict[contentKey] ?? "", avatar: dict[avatarKey] ?? "", date: formattedDateString)
                    feed.append(tweet)
                }
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
}
