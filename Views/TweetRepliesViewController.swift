//
//  TweetRepliesViewController.swift
//  OpenTweet
//
//  Created by Joe H on 10/11/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

var tweetThread = [Tweet]()

class TweetRepliesViewController: UIViewController {
    
    var selectedTweet: Tweet!
    
    @IBOutlet weak var tweetRepliesTableView: UITableView!
    
    //TODO: Make sure assets are used properly

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Display a loading indicator
        
        tweetRepliesTableView.dataSource = self
        tweetRepliesTableView.rowHeight = UITableView.automaticDimension
        tweetRepliesTableView.estimatedRowHeight = 600
        
        //Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets), name: .tweetThreadCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAvatarAt(_:)), name: .cellAvatarCached, object: nil)
        
        DispatchQueue.global(qos: .background).async {
            //If the tweet is a root tweet the get all the replies
            tweetThread = TweetTimeline.getTweetThreadWith(selectedTweet: self.selectedTweet, timeline: tweetTimeline)
        }
    }
    
    @objc
    func reloadTweets() {
        //TODO: Reload with animation
        //Reload the data
        DispatchQueue.main.async {
            self.tweetRepliesTableView.reloadData()
        }
    }
    
    @objc
    func reloadAvatarAt(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let rowIndex = userInfo[Constants.rowIndexKey] {
                let rowIndexPath = IndexPath(row: rowIndex as! Int, section: 0);
                DispatchQueue.main.async {
                    //TODO: Consider animation
                    self.tweetRepliesTableView.reloadRows(at: [rowIndexPath], with: .none)
                }
            }
        }
    }
    
    //If our tweet thread gets too big then clear it
    override func didReceiveMemoryWarning() {
        tweetThread = [Tweet]()
    }
}

extension TweetRepliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        //Get the tweet
        var tweet = Tweet()
        //Will stop crashing if index out of range
        if tweetThread.indices.contains(indexPath.row) {
            tweet = tweetThread[indexPath.row]
        }
        
        //Load the no replies cell
        if (tweet.id == "") {
            cell.authorDateLabel.text = ""
            cell.contentLabel.text = tweet.content
            cell.avatarImageView.isHidden = true
        } else {
            //Load the tweet cell
            cell = TweetCellHelper.setupWith(cell: cell, tweet: tweet, rowIndex: indexPath.row, repliesView: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetThread.count
    }
}
