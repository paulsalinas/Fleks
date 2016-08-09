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
    private var selectedExercise: Exercise!
    
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
        selectedExercise = viewModel.exercises[indexPath.row]
        performSegueWithIdentifier("EnterSetDetailsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EnterSetDetailsSegue") {
            let vc = segue.destinationViewController as! ExerciseSetFormViewController
            let tabBarController = self.tabBarController as! FleksTabBarController
            vc.injectDependency(tabBarController.createExerciseSetViewModel(selectedExercise, order: workout.exerciseSets.count + 1, workout: workout))
        }
    }
}
