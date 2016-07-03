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
            fireBaseClient.userDataRef.child("exercises").observeEventType(FIRDataEventType.ChildAdded, withBlock: { snap in
                self.exercises.append(Exercise(snapshot: snap, muscles: self.fireBaseClient.muscles.filter { snap.childSnapshotForPath("muscles").hasChild($0.id) } ))
                self.delegate?.dataManager(self, didInsertRowAtIndexPath: NSIndexPath(forItem: self.exercises.count - 1, inSection: 0))
            })
        }
    }
    
    func createExercise(name: String, muscles: [Muscle]) {
        fireBaseClient.creatExercise(name, muscles: muscles)
    }
    
    init(firebaseClient: FirebaseClient) {
        self.fireBaseClient = firebaseClient
        self.exercises = fireBaseClient.exercises
    }
}
