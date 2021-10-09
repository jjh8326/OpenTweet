//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    let tweets = Tweets.feedFromBundle()
    @IBOutlet weak var timelineTableView: UITableView!
    
	override func viewDidLoad() {
		super.viewDidLoad()

        timelineTableView.dataSource = self
        timelineTableView.rowHeight = UITableView.automaticDimension
        timelineTableView.estimatedRowHeight = 600
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        
        cell.authorLabel.text = tweet.author
        //cell.dateLabel.text = tweet.date
        cell.contentLabel.text = tweet.content
        
        //TODO: Get image
        //cell.authorImageView.image = tweet.avatar
        cell.authorImageView.layer.cornerRadius = cell.authorImageView.frame.size.width / 2
        
        let height = cell.heightAnchor
        
        print(height)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

