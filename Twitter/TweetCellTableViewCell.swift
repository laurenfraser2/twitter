//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Lauren Fraser on 3/1/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetsContent: UILabel!
    
    @IBOutlet weak var rtButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
  
    @IBAction func retweetTweet(_ sender: Any) {
        TwitterAPICaller.client?.retweetTweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: {(error) in print("error retweeting: \(error)")})
    }
    
    var favorited:Bool = false
    var tweetId:Int = -1


    func setRetweeted(_ isRetweeted: Bool){
        if(isRetweeted){
            rtButton.setImage(UIImage (named:"retweet-icon-green"), for: UIControl.State.normal)
            rtButton.isEnabled = false
        } else {
            rtButton.setImage(UIImage (named:"retweet-icon"), for: UIControl.State.normal)
            rtButton.isEnabled = true
        }
    }
    func setFavorited(_ isFavorited: Bool){
        favorited = isFavorited
        if(favorited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if(toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Favorite did not succeed\(error)")
            })
        } else{
                TwitterAPICaller.client?.unfavoriteTweet(tweetId: self.tweetId, success: {
                    self.setFavorited(false)
                }, failure: { (error) in
                    print("Unable to unfavorite")
            })
        }
    }
    
   
 

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
