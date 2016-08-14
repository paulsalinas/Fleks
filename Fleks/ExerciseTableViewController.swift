//
//  ExerciseTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UITableViewController, ActivityOverlayable, Alertable {
    var activityOverlay: ActivityOverlay?
    
    private var viewModel: ExercisesViewModel!
    private var dataStore: DataStore!
    
    
    override func viewDidLoad() {
        self.viewModel.refreshSignalProducer()
            .on(started:{ _ in self.startOverlay() }, next: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
            .startWithNext { _ in self.tableView.reloadData() }
        
         super.viewDidLoad()
    }
    
    func injectDependency(dataStore: DataStore) {
        self.dataStore = dataStore
        self.viewModel = ExercisesViewModel(dataStore: dataStore)
    }
    
    @IBAction func addButtonTouch(sender: AnyObject) {
        performSegueWithIdentifier("ShowExerciseForm", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExerciseForm" ) {
            let addExerciseController = segue.destinationViewController as! AddExerciseViewController
            addExerciseController.injectDependencies(dataStore, onDone: { name, selectedMuscles in
                return { _ in
                    self.viewModel.createExercise(name, muscles: selectedMuscles)
                        .on(started:{ _ in self.startOverlay() }, next: { _ in self.stopOverlay() })
                        .start()
                }
            })
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfExercisesInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let exercise = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
        return cell
    }
}
