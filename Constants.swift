//
//  Constants.swift
//  OpenTweet
//
//  Created by Joe H on 10/8/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

class Constants {
    static let dataFileName = "timeline"
    static let dataFileType = "json"
    
    //Tweet data keys
    static let idKey = "id"
    static let authorKey = "author"
    static let contentKey = "content"
    static let avatarKey = "avatar"
    static let dateKey = "date"
    static let inReplyToKey = "inReplyTo"

    static let isoDateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let requiredDateFormatString = "MM/dd/YYY 'at' hh:mm a"
    
    static let rowIndexKey = "rowIndex"
    static let noRepliesMessage = "There are no replies."
    static let originalMessage = "Original message:\n%@"
    
    static let defaultAvatarName = "defaultAvatar"
    
    static let tweetTimelineKey = "tweetTimeline"
    static let tweetThreadKey = "tweetThread"
    
    static let atPrefix = "@"
    static let newLine = "\n"
    static let httpPrefix = "http://"
    static let httpsPrefix = "https://"
    
    static let tweetCellIdentifier = "TweetCell"
}
