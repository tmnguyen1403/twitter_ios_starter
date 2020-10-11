//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Tom Riddle on 10/5/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
  
    var tweetArray = [NSDictionary]();
    var numberOfTweet: Int!;
    
    let myRefreshControl = UIRefreshControl();
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets();
        
      myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged);
      tableView.refreshControl = myRefreshControl;
      self.tableView.rowHeight = UITableView.automaticDimension;
      self.tableView.estimatedRowHeight = 150;
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    self.loadTweets();
  }
    
  @objc func loadTweets() {
    
    numberOfTweet = 20;
    let url = "https://api.twitter.com/1.1/statuses/home_timeline.json";
    let myParams = ["count": numberOfTweet];
    
    TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams, success: { (tweets: [NSDictionary]) in
      print("Get Tweets succesfully");
      self.tweetArray.removeAll();
        
      for tweet in tweets {
        self.tweetArray.append(tweet);
      }
      self.tableView.reloadData();
      self.myRefreshControl.endRefreshing();
      
    }, failure: { (Error) in
      print("Could not retrieve tweets!");
    });
  }
  

  
  func loadMoreTweets() {
    let url = "https://api.twitter.com/1.1/statuses/home_timeline.json";
    
    numberOfTweet += 20;
    let myParams = ["count": numberOfTweet];
    
    TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams, success: { (tweets: [NSDictionary]) in
      print("Get Tweets succesfully");
      self.tweetArray.removeAll();
        
      for tweet in tweets {
        self.tweetArray.append(tweet);
      }
      self.tableView.reloadData();
    }, failure: { (Error) in
      print("Could not retrieve tweets!");
    });
  }
  
  //load more tweets when user reach the end of the page
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row + 1 == tweetArray.count {
      loadMoreTweets();
    }
  }
  
    @IBAction func onLogout(_ sender: Any) {
      TwitterAPICaller.client?.logout();
      UserDefaults.standard.set(false, forKey: "userLoggedIn");
      self.dismiss(animated: true, completion: nil);
    }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell;
    
    let user = tweetArray[indexPath.row]["user"] as! NSDictionary;
    //load image
    let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!);
    let data = try? Data(contentsOf: imageUrl!);
    
    if let imageData = data {
      cell.profileImageView.image = UIImage(data: imageData);
    }
    //
    cell.userNameLabel.text = user["name"] as! String;
    cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as! String;
    
    if let favorited = tweetArray[indexPath.row]["favorited"] {
      cell.setFavorite(favorited as! Bool);
    }
    if let tweetId = tweetArray[indexPath.row]["id"]  {
      cell.tweetId = tweetId as! Int;
    }
    
    return cell;
  }
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return tweetArray.count;
    }

}
