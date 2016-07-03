//
//  ViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-21.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    private var client: FirebaseClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email"];
        client = FirebaseClient()
        
    }
    
    /* facebook button delegate to handle the result from login */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print("Facebook login failed. Error \(error)")
        } else if result.isCancelled {
            print("Facebook login was cancelled.")
        } else {
            client.loginWithFacebook(
                FBSDKAccessToken.currentAccessToken().tokenString,
                onComplete: { () in
                    self.performSegueWithIdentifier("ShowTabBar", sender: self)
                },
                onError: { error in
                    print("Login failed. \(error)")
                }
            )
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        //do nothing
        return
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowTabBar") {
            let tabBarController = segue.destinationViewController as! FleksTabBarController
            tabBarController.client = client
        }
    }
}
