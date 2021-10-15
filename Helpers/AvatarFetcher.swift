//
//  AvatarFetcher.swift
//  OpenTweet
//
//  Created by Joe H on 10/12/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class AvatarFetcher {
    //Get the avatar image
    static func fetchAvatar(withString URLString: String, rowIndex: Int) {
        //Get the avatar's image URL from the tweet
        if let avatarURL = URL(string: URLString) {
            //Download the data using a valid URL
            URLSession.shared.dataTask(with: avatarURL) { data, response, error in
                //If something happened when retrieving the image then print the error
                if error != nil {
                    print(error!)
                }
                //Need to have several checks because you can still retrieve no data or a bad image
                if let imageData = data {
                    if !imageData.isEmpty {
                        if let image = UIImage(data: data!) {
                            avatarCache.setObject(image, forKey: URLString as NSString)
                            NotificationCenter.default.post(name: .cellAvatarCached, object: nil, userInfo: [Constants.rowIndexKey: rowIndex])
                        }
                    }
                }
            }.resume()
        }
    }
}
