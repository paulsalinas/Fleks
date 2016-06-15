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
    private var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email"];
        ref = FirebaseClient.sharedInstance().ref
        
    }
    
    /* facebook button delegate to handle the result from login */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print("Facebook login failed. Error \(error)")
        } else if result.isCancelled {
            print("Facebook login was cancelled.")
        } else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if error != nil {
                    print("Login failed. \(error)")
                } else {
                      print(user)
//                    FirebaseClient.sharedInstance().setupUser(authData)
//                    self.performSegueWithIdentifier("ShowTabBar", sender: self)
                }
            }
//            ref.authWithOAuthProvider("facebook", token: accessToken) { error, authData in
//                if error != nil {
//                    print("Login failed. \(error)")
//                } else {
//                    FirebaseClient.sharedInstance().setupUser(authData)
//                    self.performSegueWithIdentifier("ShowTabBar", sender: self)
//                }
//            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        //do nothing
        return
    }
}
