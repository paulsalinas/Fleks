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
    var userDataRef: FIRDatabaseReference!
    var muscles: [Muscle]!
    var exercises: [Exercise]!
    
    init() {
        ref.child("muscles").observeSingleEventOfType(.Value, withBlock: { muscleSnap in
            self.muscles = muscleSnap.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
            self.ref.child("exercises").observeSingleEventOfType(.Value, withBlock: { snapshot in
                self.exercises = snapshot.children.map { snap in
                    let exerciseMuscles = self.muscles.filter { snap.childSnapshotForPath("muscles").hasChild($0.id) }
                    return Exercise(snapshot: snap as! FIRDataSnapshot, muscles: exerciseMuscles)
                }
            })
        })
    }
    
    func loginWithFacebook(tokenString: String, onComplete: () -> Void, onError: (error: NSError) -> Void) {
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
    
    func creatExercise(name: String, muscles: [Muscle]) {
        let exerciseRef = userDataRef.child("exercises").childByAutoId()
        var exercise: [String: AnyObject] = ["name": name]
        var musclesDict = [String: Bool]()
        for muscle in muscles {
            musclesDict[muscle.id] = true
        }
        exercise["muscles"] = musclesDict
        exerciseRef.setValue(exercise)
    }
    
    private func setupUser(onComplete: () -> Void) {
        let userMapping = FIRDatabase.database().reference().child("user_mappings")
        let providerDataRef = FIRDatabase.database().reference().child("provider_data")
        let fbUserRef = userMapping.child(user.uid)
        let uid = user.uid
        let providerData = user.providerData[0]
        
        fbUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // user has logged in before, retrieve app_id
            if (snapshot.childrenCount > 0) {
                
                fbUserRef.child("user_id").observeSingleEventOfType(.Value, withBlock: {
                    self.userDataRef = self.ref.child("users/\($0.value as! String)")
                    onComplete()
                })
                
                // TODO: update latest provider data
                return
            }
            
            // user has NOT logged in before, set up their data
            
            self.userDataRef = self.ref.child("users").childByAutoId()
            
            self.userDataRef.child("facebook_id").setValue(uid)
            fbUserRef.child("user_id").setValue(self.userDataRef.key)
            
            providerDataRef.child("\(uid)/email" ).setValue(providerData.email)
            providerDataRef.child("\(uid)/providerId" ).setValue(providerData.providerID)
            providerDataRef.child("\(uid)/displayName" ).setValue(providerData.displayName)
            providerDataRef.child("\(uid)/photoUrl" ).setValue(providerData.photoURL!.absoluteString)
            onComplete()
        })
    }
    
    func fetchData() {
        
    }
}
