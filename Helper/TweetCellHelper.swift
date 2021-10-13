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
    static func setupWith(cell: TweetTableViewCell, tweet: Tweet, rowIndex: Int, repliesView: Bool) -> TweetTableViewCell {
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        cell.contentLabel.text = tweet.content
        
        //Set the default avatar for now
        cell.avatarImageView.image = UIImage(named: Constants.defaultAvatarName)

        
        //Make the avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
        if (tweet.avatarURL != "") {
            //If the image exists in the cache then set the avatar's image
            if let image = avatarCache.object(forKey: tweet.avatarURL as NSString) {
                //If the retreived image is valid then set it
                if image.size != CGSize(width: 0,height: 0) {
                    cell.avatarImageView.image = image
                }
            } else {
                DispatchQueue.global(qos: .background).async {
                    //If the image is not in the cache then queue it up for fetching and setting
                    AvatarFetcher.getAvatarWith(avatarURLString: tweet.avatarURL, rowIndex: rowIndex)
                }
            }
        }
        
        //Work-around to fix iOS issue where cell image does not load
        cell.setNeedsLayout()
        
        return cell
    }
}
