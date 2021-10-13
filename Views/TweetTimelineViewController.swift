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
        
        //Add observers for our notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets), name: .bundleDataParsed, object: nil)
    }
    
    @objc
    func reloadTweets() {
        //Reload the data
        DispatchQueue.main.async {
            self.tweetTimelineTableView.reloadData()
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
        cell = TweetCellHelper.setupWith(cell: cell, tweet: tweets[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
