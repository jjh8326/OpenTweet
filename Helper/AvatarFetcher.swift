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
        var avatarObject = [UIImage]()
        //Get the avatar's image URL from the tweet
        guard let url = URL(string: avatarURL) else {
            print("Invalid URL used")
            return []
        }
        //Download the data using a valid URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            //If something happened when retrieving the image then return an empty array
            if error != nil {
                print(error!)
            }
            //Need to have many checks because you can still retrieve no data or a bad image
            if let imageData = data {
                if !imageData.isEmpty {
                    if let image = UIImage(data: data!) {
                        avatarObject.append(image)
                    }
                }
            }
        }.resume()

        return avatarObject
    }
}
