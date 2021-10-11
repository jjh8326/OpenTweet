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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedTweet.id)
        print("DONE")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
