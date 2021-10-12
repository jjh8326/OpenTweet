//
//  TweetRepliesViewController.swift
//  OpenTweet
//
//  Created by Joe H on 10/11/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetRepliesViewController: UIViewController {
    
    var selectedTweet: Tweet!
    var tweetThread = [Tweet]()
    
    @IBOutlet weak var tweetRepliesTableView: UITableView!
    
    //@IBOutlet weak var tweetThreadTableView: UITableView!
    
    //TODO: Make sure assets are used properly

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DONE?: Display a tweet's thread when tapping on a giving tweet. Due to the very simplistic data model made available to you, it's probably best to simplify this: if the user taps on the first tweet of a thread, display all the replies in ascending chronological order,
        if self.selectedTweet.reply == "" {
            DispatchQueue.global(qos: .background).async {
                //TODO: Consider order of replies
                
                //If the tweet is a root tweet the get all the replies
                self.tweetThread = TweetTimeline.getTweetRepliesFor(rootTweetID: self.selectedTweet.id, timeline: tweets)
            }
        } else {
            //First tweet in the thread should be the selected tweet
            DispatchQueue.global(qos: .background).async { [self] in
                for i in 0..<tweets.count {
                    //If the tweet is the tweet the selected tweet is replying to then add it to our tweet thread
                    if tweets[i].id == self.selectedTweet.reply {
                        self.tweetThread.append(tweets[i])
                    }
                }
                
                //TODO: Consider making Tweet a class so the content can change
                let rootTweet = tweetThread[0]
                
                //Format the content so a user knows its a response to tweet below it
                let updatedRootContent = String(format: "Original message: %@", rootTweet.content)
                
                //TODO: Consider making Tweet a class so the content can change
                let updatedRootTweet = Tweet(id: rootTweet.id, author: rootTweet.author, content: updatedRootContent, avatarURL: rootTweet.avatarURL, date: rootTweet.date, viewDate: rootTweet.viewDate, reply: rootTweet.reply)
                
                tweetThread = [self.selectedTweet, updatedRootTweet]
            }
            
            //TODO: Display a loading indicator
        }
        
        tweetRepliesTableView.dataSource = self
        tweetRepliesTableView.rowHeight = UITableView.automaticDimension
        tweetRepliesTableView.estimatedRowHeight = 600
        
        //Add observers for our notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets), name: .tweetThreadCreated, object: nil)
    }
    
    @objc
    func reloadTweets() {
        //Reload the data
        DispatchQueue.main.async {
            self.tweetRepliesTableView.reloadData()
        }
    }
    
    //If our tweet thread gets too big then clear it
    override func didReceiveMemoryWarning() {
        tweetThread = [Tweet]()
    }
}

//TODO: Duplicate code!
extension TweetRepliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        let tweet = tweetThread[indexPath.row]
        
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        cell.contentLabel.text = tweet.content
        
        //Make our avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
        
        //TODO: Delete below test code
        if (tweet.avatarURL == "") {
            print("HERE - index = %i", indexPath.row)
        }
        
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
        
        //Load the no replies view
        if (tweet.id == "") {
            cell.authorDateLabel.text = ""
            cell.avatarImageView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetThread.count
    }
}
