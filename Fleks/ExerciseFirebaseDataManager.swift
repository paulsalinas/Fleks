//
//  ExerciseFirebaseDataManager.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-06-26.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ExerciseFirebaseDataManager: NSObject {
    
    var fireBaseClient: FirebaseClient
    var exercises: [Exercise]
    
    var delegate: DataManagerDelegate? {
        didSet {
            // TODO: bind reference observers to delegate methods
            fireBaseClient.ref.child("exercises").observeEventType(FIRDataEventType.ChildAdded, withBlock: { snap in
                
            })
        }
    }
    
    init(firebaseClient: FirebaseClient) {
        self.fireBaseClient = firebaseClient
        self.exercises = fireBaseClient.exercises
    }
}
