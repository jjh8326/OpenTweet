//
//  Tweet.swift
//  OpenTweet
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

class Tweet {
    let id: String
    let author: String
    let content: String
    let avatarURL: String
    //Store JSON's date for future sorting
    let date: String
    //Store the formatted date for view presentation
    let viewDate: String
    let reply: String
    
    init() {
        self.id = ""
        self.author = ""
        self.content = ""
        self.avatarURL = ""
        self.date = ""
        self.viewDate = ""
        self.reply = ""
    }
    
    init(id: String,
         author: String,
         content: String,
         avatarURL: String,
         date: String,
         viewDate: String,
         reply: String) {
        self.id = id
        self.author = author
        self.content = content
        self.avatarURL = avatarURL
        self.date = date
        self.viewDate = viewDate
        self.reply = reply
    }
}
