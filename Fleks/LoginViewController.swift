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
    
    private var viewModel: LoginViewModel!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email"];
    }
    
    func injectDependencies(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    /* facebook button delegate to handle the result from login */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print("Facebook login failed. Error \(error)")
        } else if result.isCancelled {
            print("Facebook login was cancelled.")
        } else {
            viewModel.loginWithFacebook(
                FBSDKAccessToken.currentAccessToken().tokenString,
                onComplete: { user in
                    self.user = user
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "ShowTabBar") {
//         //    onCompleteLoginSegue(segue: segue)
//        }
//    }
}
