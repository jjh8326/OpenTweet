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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Display a loading indicator
        
        tweetRepliesTableView.dataSource = self
        tweetRepliesTableView.rowHeight = UITableView.automaticDimension
        tweetRepliesTableView.estimatedRowHeight = 600
        
        //Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets(_:)), name: .tweetThreadCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAvatarAt(_:)), name: .cellAvatarCached, object: nil)
        
        DispatchQueue.global(qos: .background).async {
            //If the tweet is a root tweet then get all the replies, if the tweet is a reply to another tweet then display that tweet and the tweet it is replying to
            TweetTimeline.fetchTweetThread(withSelectedTweet: self.selectedTweet, timeline: tweetTimeline)
        }
    }
    
    @objc
    func reloadTweets(_ notification: NSNotification) {
        //Get the timeline from the notification
        if let userInfo = notification.userInfo {
            if let tweets = userInfo[Constants.tweetThreadKey] {
                tweetThread = tweets as! [Tweet]
            }
        }
        
        //TODO: Reload with animation
        
        //Reload the data
        DispatchQueue.main.async {
            self.tweetRepliesTableView.reloadData()
        }
    }
    
    @objc
    func reloadAvatarAt(_ notification: NSNotification) {
        //Get the avatar from the notification
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
        let cell = tableView.dequeueReusableCell(
          withIdentifier: Constants.tweetCellIdentifier,
          for: indexPath) as! TweetTableViewCell
        
        //Get the tweet
        var tweet = Tweet()
        //Will stop the app from crashing if index is out of range
        if tweetThread.indices.contains(indexPath.row) {
            tweet = tweetThread[indexPath.row]
        }
        
        //Configure the tweet cell
        cell.configureCell(withTweet: tweet, rowIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetThread.count
    }
}
