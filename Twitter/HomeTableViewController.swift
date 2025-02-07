//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Lauren Fraser on 2/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    
    var tweetarray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
        
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector((loadTweets)), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
     

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    
    
    @objc func loadTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = 20
        let myParams = ["count": numberOfTweets ]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetarray.removeAll()
            for tweet in tweets{
                self.tweetarray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
       
    }
    
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetarray.removeAll()
            for tweet in tweets{
                self.tweetarray.append(tweet)
            }
            
            self.tableView.reloadData()
   
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
        
    }
   
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetarray.count{
            loadMoreTweets()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        
        let user = tweetarray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetsContent.text = tweetarray[indexPath.row]["text"] as? String
 
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorited(tweetarray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetarray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetarray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
        
    }
    
    

    // MARK: - Table view data source

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey:"UserLoggedIn")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetarray.count
    }

   
}
