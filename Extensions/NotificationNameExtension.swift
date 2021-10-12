//
//  NotificationNameExtension.swift
//  OpenTweet
//
//  Created by Joe H on 10/9/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let bundleDataParsed = NSNotification.Name(rawValue: "BundleDataParsed")
    static let tweetThreadCreated = NSNotification.Name(rawValue: "TweetThreadCreated")
}
