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
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        cell.contentLabel.text = tweet.content
        
        //Make our avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

