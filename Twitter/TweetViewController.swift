//
//  TweetViewController.swift
//  Twitter
//
//  Created by Tom Riddle on 10/11/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

  @IBOutlet weak var tweetTextView: UITextView!
  override func viewDidLoad() {
        super.viewDidLoad()
    tweetTextView.becomeFirstResponder();
        // Do any additional setup after loading the view.
    }
    

  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil);
  }
 
  @IBAction func tweet(_ sender: Any) {
    if let text = tweetTextView.text {
      TwitterAPICaller.client?.postTweet(tweetString: text, success: {
        self.dismiss(animated: true, completion: nil);
      }, failure: { (error) in
        print("Error posting tweet \(error)");
        self.dismiss(animated: true, completion: nil);
      })
    } else {
      print("Please put some text");
      self.dismiss(animated: true, completion: nil);
    }
  }

}
