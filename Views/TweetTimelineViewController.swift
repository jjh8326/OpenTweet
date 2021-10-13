//
//  TweetTimelineViewController.swift
//  OpenTweet
//
//  Created by Joe H on 10/09/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

var avatarCache: NSCache = NSCache<NSString, UIImage>()
var tweets = [Tweet]()

class TweetTimelineViewController: UIViewController {
    //Data structure to hold our tweet replies, ordered by date
    var tweetReplies = [String: [Tweet]]()
    
    @IBOutlet weak var tweetTimelineTableView: UITableView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            tweets = TweetTimeline.feedFromBundle()
        }

        tweetTimelineTableView.dataSource = self
        tweetTimelineTableView.rowHeight = UITableView.automaticDimension
        tweetTimelineTableView.estimatedRowHeight = 600
        
        //Add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets), name: .bundleDataParsed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAvatarAt(_:)), name: .cellAvatarCached, object: nil)
    }
    
    @objc
    func reloadTweets() {
        //TODO: Reload with animation
        //Reload the data
        DispatchQueue.main.async {
            self.tweetTimelineTableView.reloadData()
        }
    }
    
    @objc
    func reloadAvatarAt(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let rowIndex = userInfo[Constants.rowIndexKey] {
                let rowIndexPath = IndexPath(row: rowIndex as! Int, section: 0);
                DispatchQueue.main.async {
                    //TODO: Consider animation
                    self.tweetTimelineTableView.reloadRows(at: [rowIndexPath], with: .none)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? TweetRepliesViewController,
        let indexPath = tweetTimelineTableView.indexPathForSelectedRow {
        destination.selectedTweet = tweets[indexPath.row]
      }
    }
}

extension TweetTimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        //Get the tweet
        cell = TweetCellHelper.setupWith(cell: cell, rowIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
