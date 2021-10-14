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
        //TODO: Ability to toglge on / off the view date
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        //Make the content text pretty
        cell.contentLabel.attributedText = stylizeTextWith(tweetContent: tweet.content)
        
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
        
        //Potential work-around to fix iOS issue where cell image does not load
        cell.setNeedsLayout()
        
        return cell
    }
    
    //Check the content text for authors (@ signs) and links, then style them appropriately
    private static func stylizeTextWith(tweetContent: String) -> NSAttributedString {
        //If the tweet doesn't have mentions or links then just return original contents as attributed text
        guard (tweetContent.contains("@") || tweetContent.contains("https://") || tweetContent.contains("http://")) else {
            return NSMutableAttributedString(string: tweetContent)
        }
        
        //Change new line characters so that they have spaces and can not be lost when splitting string by spaces
        let changedNewLineChars = tweetContent.replacingOccurrences(of: "\n", with: " \n ")
        //Split string by spaces for easy looping
        let wordList = changedNewLineChars.components(separatedBy: " ")
        let attributedTextContent = NSMutableAttributedString()
        
        //If the tweet contains mentions or links then loop through the word list and format them
        if (tweetContent.contains("@") || tweetContent.contains("https://") || tweetContent.contains("http://")) {
            //Bold the username
            for i in 0..<wordList.count {
                var attributedWord = NSMutableAttributedString(string: wordList[i])
                //Could combine the if checks into one and not need the else if but I left it like this in case there is a desire to customize the link text further
                //Both username highlights and link highlights are same color because this is similar to what twitter does
                if (wordList[i].hasPrefix("@")) {
                    //"Highlight" username mentions
                    attributedWord = NSMutableAttributedString(string: wordList[i], attributes: [.foregroundColor: UIColor.cyan])
                } else if (wordList[i].hasPrefix("http://")) || (wordList[i].hasPrefix("https://")) {
                    attributedWord = NSMutableAttributedString(string: wordList[i], attributes: [.foregroundColor: UIColor.cyan])
                }
                //Add a space to the end of the word but only if its not a new line "word"
                if (!attributedWord.isEqual(to: NSMutableAttributedString(string:"\n"))) {
                    attributedWord.append(NSMutableAttributedString(string:" "))
                }
                //Add the word to the full text
                attributedTextContent.append(attributedWord)
            }
        }
        return attributedTextContent
    }
}
