//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

var avatarCache: NSCache = NSCache<NSString, UIImage>()

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
        cell.contentLabel.text = tweet.content
        
        //Make our avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
        if (tweet.avatarURL != "") {
            //Get the avatar's image URL from the tweet
            guard let url = URL(string: tweet.avatarURL) else {
                print("Invalid URL used")
                return cell
            }
            //If the image exists in the cache then set the avatar's image
            if let image = avatarCache.object(forKey: tweet.avatarURL as NSString) {
                cell.avatarImageView.image = image
            } else {
                //If it does not exist then download it
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let image = UIImage(data: data!) {
                        avatarCache.setObject(image, forKey: tweet.avatarURL as NSString)
                        DispatchQueue.main.async {
                            cell.avatarImageView.image = image
                        }
                    }
                }.resume()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}

