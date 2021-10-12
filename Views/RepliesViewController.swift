//
//  RepliesViewController.swift
//  OpenTweet
//
//  Created by Joe H on 10/11/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class RepliesViewController: UIViewController {
    
    var selectedTweet: Tweet!
    var tweetThread = [Tweet]()
    
    @IBOutlet weak var tweetThreadTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            //TODO: If a tweet is a reply to a tweet then show that as the first tweet
            //TODO: Consider order of replies
            self.tweetThread = Timeline.getTweetRepliesFor(rootTweetID: self.selectedTweet.id, timeline: tweets)
        }
        
        tweetThreadTableView.dataSource = self
        tweetThreadTableView.rowHeight = UITableView.automaticDimension
        tweetThreadTableView.estimatedRowHeight = 600
        
        //Add observers for our notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTweets), name: .tweetThreadCreated, object: nil)
    }
    
    @objc
    func reloadTweets() {
        //Reload the data
        DispatchQueue.main.async {
            self.tweetThreadTableView.reloadData()
        }
    }
    
    //If our tweet thread gets too big then clear it
    override func didReceiveMemoryWarning() {
        tweetThread = [Tweet]()
    }
}

//TODO: Duplicate code!
extension RepliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "TweetCell",
          for: indexPath) as! TweetTableViewCell
        
        let tweet = tweetThread[indexPath.row]
        
        cell.authorDateLabel.text = tweet.author + " - " + tweet.viewDate
        cell.contentLabel.text = tweet.content
        
        //Make our avatar's image circular
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.size.width / 2
        
        //TODO: Create extension for UIImage here, also duplicate code
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
        return tweetThread.count
    }
}
