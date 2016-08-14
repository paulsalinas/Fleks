//
//  SelectExercisesTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class SelectExercisesTableViewController: UITableViewController, ActivityOverlayable, Alertable {
    
    var activityOverlay: ActivityOverlay?
    
    var dataStore: DataStore!
    
    private var viewModel: ExercisesViewModel!
    private var selectedExercise: Exercise!
    private var onSubmitUpdate: (selectedExercise: Exercise, reps: Int, sets: Int, notes: String) -> () -> Void = { _ in  { _ in  () } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = true
        viewModel.refreshSignalProducer()
            .on(started:{ _ in self.startOverlay() }, next: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
            .startWithNext { _ in
                self.tableView.reloadData()
            }
    }
    
    @IBAction func cancelTouchUp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func injectDependency(dataStore: DataStore, onSubmitUpdate: (selectedExercise: Exercise, reps: Int, sets: Int, notes: String) -> () -> Void) {
        self.dataStore = dataStore
        self.onSubmitUpdate = onSubmitUpdate
        self.viewModel = ExercisesViewModel(dataStore: dataStore)
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfExercisesInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectExerciseCell", forIndexPath: indexPath)
        let exercise = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedExercise = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        performSegueWithIdentifier("EnterSetDetailsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EnterSetDetailsSegue") {
            let vc = segue.destinationViewController as! ExerciseSetFormViewController
            vc.injectDependency(dataStore, onSubmitUpdate: { reps, sets, notes in
                self.onSubmitUpdate(selectedExercise: self.selectedExercise, reps: reps, sets: sets, notes: notes)
            })
        }
    }
}
