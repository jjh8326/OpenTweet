//
//  TweetCellHelper.swift
//  OpenTweet
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetCellHelper {
    static func setupWith(cell: TweetTableViewCell, rowIndex: Int, repliesView: Bool) -> TweetTableViewCell {
        
        let tweet: Tweet
        
        if repliesView {
            //Get the tweet from the tweet thread
            tweet = tweetThread[rowIndex]
        } else {
            //Get the tweet from the tweets (main timeline)
            tweet = tweets[rowIndex]
        }
        
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        cell.contentLabel.text = tweet.content
        
        //Make the avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
        if (tweet.avatarURL != "") {
            //If the image exists in the cache then set the avatar's image
            if let image = avatarCache.object(forKey: tweet.avatarURL as NSString) {
                cell.avatarImageView.image = image
            } else {
                DispatchQueue.global(qos: .background).async {
                    //If the image is not in the cache then queue it up for fetching and setting
                    AvatarFetcher.getAvatarWith(avatarURLString: tweet.avatarURL, rowIndex: rowIndex)
                }
            }
        }
        return cell
    }
}
