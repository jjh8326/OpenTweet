//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    var tweets = [Tweet]()
    @IBOutlet weak var timelineTableView: UITableView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            self.tweets = Tweets.feedFromBundle()
        }

        timelineTableView.dataSource = self
        timelineTableView.rowHeight = UITableView.automaticDimension
        timelineTableView.estimatedRowHeight = 600
        
        //Add observers for our notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets), name: .timelineDataParsed, object: nil)
    }
    
    @objc
    func reloadTweets() {
        //Reload the data
        DispatchQueue.main.async {
            self.timelineTableView.reloadData()
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        
        cell.authorDateLabel.text = tweet.author + " - " + tweet.date
        //cell.dateLabel.text = tweet.date
        cell.contentLabel.text = tweet.content
        
        //TODO: Get image
        //cell.authorImageView.image = tweet.avatar
        cell.authorImageView.layer.cornerRadius = cell.authorImageView.frame.size.width / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

