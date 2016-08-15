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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, ActivityOverlayable, Alertable {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    private var viewModel: LoginViewModel!
    var user: User?
    
    var activityOverlay: ActivityOverlay?
    
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
            self.alert("Something was wrong with your FB login!")
        } else if result.isCancelled {
           print("user cancelled")
        } else {
            viewModel.loginWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString)
                .on(
                    started: { self.startOverlay() },
                    failed: { _ in
                        self.alert("Something went wrong with your login!")
                        self.stopOverlay()
                    },
                    next: { user in
                        self.user = user
                        self.performSegueWithIdentifier("ShowTabBar", sender: self)
                    },
                    completed: { self.stopOverlay() })
                .start()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        //do nothing
        return
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTabBar" {
            if let vc = segue.destinationViewController as? FleksTabBarController, user = user {
                let store = FIRDatabase.database()
                let dataStore = FireBaseDataStore(firebaseDB: store, user: user)
                vc.injectDependencies(dataStore, onSignOut: {
                    self.viewModel.logout()
                    FBSDKLoginManager().logOut()
                })
            }
        }
    }
}
