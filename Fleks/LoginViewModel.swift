//
//  LoginViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-12.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

public class LoginViewModel {
    let store: FIRDatabase
    private var user: FIRUser!
    private var ref: FIRDatabaseReference! {
        get {
            return store.reference()
        }
    }
    
    init (store: FIRDatabase) {
        self.store = store
    }
    
    func loginWithFacebook(tokenString: String, onComplete: User -> Void, onError: (error: NSError) -> Void) {
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error  {
                onError(error: error)
            } else if let user = user {
                self.user = user
                self.setupUser(onComplete)
            }
        }
    }

    private func setupUser(onComplete: User -> Void) {
        let userMapping = FIRDatabase.database().reference().child("user_mappings")
        let providerDataRef = FIRDatabase.database().reference().child("provider_data")
        let fbUserRef = userMapping.child(user.uid)
        let uid = user.uid
        let providerData = user.providerData[0]
        
        fbUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // user has logged in before, retrieve app_id
            if (snapshot.childrenCount > 0) {
                
                fbUserRef.child("user_id").observeSingleEventOfType(.Value, withBlock: {
                    onComplete(
                        User(
                            uid: uid,
                            universalId: $0.value as! String
                        )
                    )
                })
                
                // TODO: update latest provider data
                return
            }
            
            // user has NOT logged in before, set up their data
            
            let userDataRef = self.ref.child("users").childByAutoId()
            
            userDataRef.child("facebook_id").setValue(uid)
            fbUserRef.child("user_id").setValue(userDataRef.key)
            
            providerDataRef.child("\(uid)/email" ).setValue(providerData.email)
            providerDataRef.child("\(uid)/providerId" ).setValue(providerData.providerID)
            providerDataRef.child("\(uid)/displayName" ).setValue(providerData.displayName)
            providerDataRef.child("\(uid)/photoUrl" ).setValue(providerData.photoURL!.absoluteString)
            onComplete(
                User(
                    uid: uid,
                    universalId: userDataRef.key
                )
            )
        })
    }

}