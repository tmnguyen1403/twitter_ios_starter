//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Tom Riddle on 10/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var tweetContentLabel: UILabel!
  
  @IBOutlet weak var favBtn: UIButton!
  @IBOutlet weak var retweetBtn: UIButton!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func retweet(_ sender: Any) {
  }
  
  @IBAction func favTweet(_ sender: Any) {
    let toBeFavorited = !favorited
    if (toBeFavorited) {
      TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
        self.setFavorite(true);
      }, failure: { (error) in
        print("Error setting favTweet \(error)");
      })
    } else {
      TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
        self.setFavorite(false);
      }, failure: { (error) in
        print("Error setting unfavoriteTweet \(error)");
      })
    }
  }
  
  var favorited: Bool = false;
  var tweetId: Int = -1;
  
  func setFavorite(_ isFavorited:Bool) {
    favorited = isFavorited;
    if (favorited) {
      favBtn.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal);
    } else {
      favBtn.setImage(UIImage(named: "favor-icon-1"), for: UIControl.State.normal);
    }
  }

}
