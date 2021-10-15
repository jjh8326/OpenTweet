//
//  TweetTableViewCell.swift
//  OpenTweet
//
//  Created by Joe H on 10/8/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    func configureCell(withTweet tweet: Tweet, rowIndex: Int) {
        //If the tweet has an id then its a normal tweet, configure the cell
        if (tweet.id != "") {
            self.authorLabel.text = tweet.author
            self.dateTimeLabel.text = tweet.viewDate
            //Make the content text pretty
            self.stylizeText(withTweetContent: tweet.content)
            
            //Set the default avatar, avatar will get set later if there is a valid avatar url
            self.avatarImageView.image = UIImage(named: Constants.defaultAvatarName)
            
            //Make the avatar's image view circular
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
            
            if (tweet.avatarURL != "") {
                //If the image exists in the cache then set the avatar's image
                if let image = avatarCache.object(forKey: tweet.avatarURL as NSString) {
                    //If the retreived image is valid then set it
                    if image.size != CGSize(width: 0,height: 0) {
                        self.avatarImageView.image = image
                    }
                } else {
                    DispatchQueue.global(qos: .background).async {
                        //If the image is not in the cache then queue it up for fetching and setting
                        AvatarFetcher.fetchAvatar(withString: tweet.avatarURL, rowIndex: rowIndex)
                    }
                }
            }
        } else {
            //If the cell has no ID then set cell up for the "no replies" view
            self.contentLabel.text = tweet.content
            self.authorLabel.isHidden = true
            self.avatarImageView.isHidden = true
            self.dateTimeLabel.isHidden = true
        }
        
        //Potential work-around to fix iOS issue where cell image does not load
        self.setNeedsLayout()
    }
    
    //Check the content text for usernames and links, then style them appropriately
    private func stylizeText(withTweetContent content: String) {
        if (content.contains(Constants.atPrefix) || content.contains(Constants.httpsPrefix) || content.contains(Constants.httpPrefix)) {
            //Change new line characters so that they have spaces and can not be lost when splitting string by spaces
            let changedNewLineChars = content.replacingOccurrences(of: Constants.newLine, with: " \n ")
            //Split string by spaces for easy looping
            let wordList = changedNewLineChars.components(separatedBy: " ")
            let attributedTextContent = NSMutableAttributedString()
            
            //If the tweet contains mentions or links then loop through the word list and format them
            for i in 0..<wordList.count {
                var attributedWord = NSMutableAttributedString(string: wordList[i])
                //The if / else if checks could be combined into one and not need the else if, I left it like this in case there is a desire to customize the link text further
                //Both username highlights and link highlights are same color because this is similar to what twitter does
                if (wordList[i].hasPrefix(Constants.atPrefix)) {
                    //Stylize username mentions
                    attributedWord = NSMutableAttributedString(string: wordList[i], attributes: [.foregroundColor: UIColor.cyan])
                } else if (wordList[i].hasPrefix(Constants.httpPrefix)) || (wordList[i].hasPrefix(Constants.httpsPrefix)) {
                    //Stylize links
                    attributedWord = NSMutableAttributedString(string: wordList[i], attributes: [.foregroundColor: UIColor.cyan])
                }
                
                //Add a space to the end of the word but only if it's not a new line "word"
                if (!attributedWord.isEqual(to: NSMutableAttributedString(string:Constants.newLine))) {
                    attributedWord.append(NSMutableAttributedString(string:" "))
                }
                //Add the word to the full text
                attributedTextContent.append(attributedWord)
            }
            //Set the content label's attributed text
            self.contentLabel.attributedText = attributedTextContent
        } else {
            //If the tweet doesn't have mentions or links then just set original content as attributed text
            self.contentLabel.attributedText = NSMutableAttributedString(string: content)
        }
    }
}
