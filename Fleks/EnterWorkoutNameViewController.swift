//
//  EnterWorkoutNameViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class EnterWorkoutNameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var client: FirebaseClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSelectExercise" {
            if let destinationController = segue.destinationViewController as? SelectExercisesTableViewController {
                
                if let name = nameTextField.text {
                    client.workoutRef.childByAutoId().setValue(["name": name])
                } else {
                    // TODO: fail with message!
                }
            }
        }
     }

}
