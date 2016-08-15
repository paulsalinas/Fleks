//
//  LoginViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-12.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase
import ReactiveCocoa
import Result

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
    
    func loginWithFacebook(tokenString: String) -> SignalProducer<User, NSError> {
        return SignalProducer { observer, _ in
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if let error = error  {
                    observer.sendFailed(error)
                } else if let user = user {

                    self.user = user
                    self.setupUser()
                        .on(next: { next in observer.sendNext(next) }, completed: { observer.sendCompleted() })
                        .start()
                }
            }
        }
    }
    
    func logout() {
        try! FIRAuth.auth()!.signOut()
    }
    
    private func setupUser() -> SignalProducer<User, NSError> {
        return SignalProducer { observer, _ in
            let userMapping = FIRDatabase.database().reference().child("user_mappings")
            let providerDataRef = FIRDatabase.database().reference().child("provider_data")
            let baseExerciseRef = FIRDatabase.database().reference().child("exercises")
            let fbUserRef = userMapping.child(self.user.uid)
            let uid = self.user.uid
            let providerData = self.user.providerData[0]
            
            fbUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                // user has logged in before, retrieve app_id
                if (snapshot.childrenCount > 0) {
                    
                    fbUserRef.child("user_id").observeSingleEventOfType(.Value, withBlock: {
                        observer.sendNext(User(uid: uid, universalId: $0.value as! String))
                        observer.sendCompleted()
                    })
                    
                    // TODO: update latest provider data
                    return
                }
                
                // user has NOT logged in before, set up their data
                
                let userDataRef = self.ref.child("users").childByAutoId()
                
                userDataRef.child("facebook_id").setValue(uid)
                fbUserRef.child("user_id").setValue(userDataRef.key)
                
                providerDataRef.child("\(uid)/email").setValue(providerData.email)
                providerDataRef.child("\(uid)/providerId").setValue(providerData.providerID)
                providerDataRef.child("\(uid)/displayName").setValue(providerData.displayName)
                providerDataRef.child("\(uid)/photoUrl").setValue(providerData.photoURL!.absoluteString)
                
                baseExerciseRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    // copy base exercises to user ref
                    userDataRef.child("exercises").setValue(snapshot.value)
                    observer.sendNext(User(uid: uid, universalId: userDataRef.key))
                    observer.sendCompleted()

                })
                
            })
        }
    }
}