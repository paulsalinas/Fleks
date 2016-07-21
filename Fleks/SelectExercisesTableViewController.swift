//
//  SelectExercisesTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class SelectExercisesTableViewController: UITableViewController {
    private var workout: Workout!
    private var viewModel: WorkoutViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = true
        viewModel.refreshExercises { _ in
            self.tableView.reloadData()
        }
    }
    
    func injectDependency(viewModel viewModel: WorkoutViewModel, workout: Workout) {
        self.viewModel = viewModel
        self.workout = workout
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectExerciseCell", forIndexPath: indexPath)
        let exercise = viewModel.exercises[indexPath.row]
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let selectedExercise = viewModel.exercises[indexPath.row]
        performSegueWithIdentifier("EnterSetDetailsSegue", sender: self)
    }
}
