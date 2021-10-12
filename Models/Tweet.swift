//
//  Tweet.swift
//  OpenTweet
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

//TODO: Make this a class
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
