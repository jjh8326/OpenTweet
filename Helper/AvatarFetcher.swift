//
//  AvatarFetcher.swift
//  OpenTweet
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class AvatarFetcher {
    //Get the avatar image, if the function fails then it sends back an empty array
    static func getImageWith(avatarURL: String) -> [UIImage] {
        var avatarImage = UIImage()
        //Get the avatar's image URL from the tweet
        guard let url = URL(string: avatarURL) else {
            print("Invalid URL used")
            return []
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            if let image = UIImage(data: data!) {
                avatarImage = image
            }
        }.resume()
        
        return [avatarImage]
    }
}
