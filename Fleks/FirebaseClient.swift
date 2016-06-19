//
//  FIrebaseClient.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-06-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient {
    
    let ref = FIRDatabase.database().reference()
    private var user: FIRUser!
    private var userDataRef: FIRDatabaseReference!
    
    func LoginWithFacebook(tokenString: String, onComplete: () -> Void, onError: (error: NSError) -> Void) {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error  {
                onError(error: error)
            } else if let user = user {
                self.user = user
                self.setupUser()
                onComplete();            }
        }
    }
    
    private func setupUser() {
        let fbRef = FIRDatabase.database().reference().child("user_mappings/facebook")
        let fbUserRef = fbRef.child(user.uid)
        
        fbUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // user has logged in before, retrieve app_id
            if (snapshot.childrenCount > 0) {
                
                fbUserRef.child("user_id").observeSingleEventOfType(.Value, withBlock: { self.userDataRef = fbRef.child("users/\($0)") })
                
                // TODO: update latest provider data
                return
            }
            
            // user has NOT logged in before, set up their data
            
            let userRef = self.ref.child("users")
                .childByAutoId()
            
            userRef.child("facebook_id")
                .setValue(self.user.uid)
            
            fbUserRef.child("user_id")
                .setValue(userRef.key)
            
            self.userDataRef = userRef
        
        })
    }
    
    func fetchData() {
        
    }
}
