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
    let data: String
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
                    let tweet = Tweet(id: dict[idKey] ?? "", author: dict[authorKey] ?? "", content: dict[contentKey] ?? "", avatar: dict[avatarKey] ?? "", data: dict[dateKey] ?? "")
                    
                    feed.append(tweet)
                }
            } else {
                print("File does not exist!")
            }
        } catch {
          print(error.localizedDescription)
        }
        //Return the array of tweets
        return feed
    }
}
