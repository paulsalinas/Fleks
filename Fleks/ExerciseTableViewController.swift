//
//  ExerciseTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UITableViewController {

    private var viewModel: ExercisesViewModel!
    private var dataStore: DataStore!
    
    
    override func viewDidLoad() {
        self.viewModel.refreshSignalProducer()
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
                return { _ in  self.viewModel.createExercise(name, muscles: selectedMuscles).start() }
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
