//
//  AddExerciseViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-27.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var muscleTableView: UITableView!
    
    var selectedMuscles: [Muscle] = [Muscle]()
    var viewModel: ExerciseViewModel!
    private var dataSource: MuscleDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muscleTableView.delegate = self
        dataSource = MuscleDataSource(
            cellReuseIdentifier: "muscleCell",
            viewModel: viewModel,
            tableView: muscleTableView,
            onSelectMuscle: { (muscle: Muscle) -> Void in
                if let foundIndex = self.selectedMuscles.indexOf(muscle) {
                    self.selectedMuscles.removeAtIndex(foundIndex)
                } else {
                    self.selectedMuscles.append(muscle)
                }
                print(self.selectedMuscles)
        })
        muscleTableView.dataSource = dataSource
    }
    
    func injectDependencies(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let valid = exerciseNameTextField.text != "" && selectedMuscles.count > 0
        
        if identifier == "unwindAddExercise" && valid {
            return true
        } else {
            // TODO: show warning dialog
            return false
        }
    }
}
