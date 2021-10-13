//
//  TweetCellHelper.swift
//  OpenTweet
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

class TweetCellHelper {
    static func setupWith(cell: TweetTableViewCell, tweet: Tweet) -> TweetTableViewCell {
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        cell.contentLabel.text = tweet.content
        
        //Make our avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
        if (tweet.avatarURL != "") {
            //If the image exists in the cache then set the avatar's image
            if let image = avatarCache.object(forKey: tweet.avatarURL as NSString) {
                cell.avatarImageView.image = image
            } else {
                //If it does not exist then download it
                DispatchQueue.global(qos: .background).async {
                    let avatarObject = AvatarFetcher.getImageWith(avatarURL: tweet.avatarURL)
                    if avatarObject.count != 0 {
                        let image = avatarObject[0]
                        avatarCache.setObject(image, forKey: tweet.avatarURL as NSString)
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
}
