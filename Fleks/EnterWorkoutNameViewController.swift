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
    private var client: FirebaseClient!
    private var viewModel: WorkoutViewModel!
    private var workout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func injectDependency(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSelectExercise" {
            if let destinationController = segue.destinationViewController as? SelectExercisesTableViewController {
                
                if let name = nameTextField.text {
                    workout = viewModel.createWorkout(name)
                    destinationController.injectDependency(viewModel: viewModel, workout: workout)
                } else {
                    // TODO: fail with message!
                }
            }
        }
     }

}
