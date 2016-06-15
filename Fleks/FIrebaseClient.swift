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
    let accessToken: String? = nil
    
    class func sharedInstance() -> FirebaseClient {
        
        struct Singleton {
            static var sharedInstance = FirebaseClient()
        }
        
        return Singleton.sharedInstance
    }
    
//    func setupUser(authData: FAuthData) {
//        let fbRef = ref.childByAppendingPath("user-mappings/facebook")
//        let providerData = authData.providerData
//        let fbUserRef = fbRef.childByAppendingPath(authData.uid)
//        
//        fbUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            
//            // user has logged in before, retrieve app_id
//            if (snapshot.childrenCount > 0) {
//                
//                // TODO: update latest provider data
//                print(snapshot.value["user_id"])
//                return
//            }
//            
//            // user has NOT logged in before, set up their data
//            
//            fbUserRef.setValue(providerData)
//            
//            let userRef = self.ref.childByAppendingPath("users")
//                .childByAutoId()
//            
//            userRef.childByAppendingPath("facebook_id")
//                .setValue(authData.uid)
//            
//            fbUserRef.childByAppendingPath("user_id")
//                .setValue(userRef.key)
//        
//        })
//    }
    
    func fetchData() {
        
    }
}
