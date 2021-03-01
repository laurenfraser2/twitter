//
//  LoginViewController.swift
//  Twitter
//
//  Created by Lauren Fraser on 2/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "UserLoggedIn") == true{
            self.performSegue(withIdentifier: "logintohome", sender: self)
        }
    }
    @IBAction func OnLoginButton(_ sender: Any) {
        let myurl = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: myurl, success:{
                                        UserDefaults.standard.set(true,  forKey: "UserLoggedIn")
            self.performSegue(withIdentifier: "logintohome", sender: self)}, failure: { (Error) in
            print("could not login")
        })
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
