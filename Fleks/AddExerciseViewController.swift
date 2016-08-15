//
//  AddExerciseViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-27.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa

class AddExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ActivityOverlayable, Alertable {
    
    var activityOverlay: ActivityOverlay?
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var muscleTableView: UITableView!
    
    private var dataStore: DataStore!
    private var viewModel: ExerciseFormViewModel!
    
    private var onDone: (name: String, selectedMuscles: [Muscle]) -> () -> Void = { _,_ in  { _ in () } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muscleTableView.delegate = self
        muscleTableView.dataSource = self
        viewModel.refreshSignalProducer()
            .startOn(UIScheduler())
            .on(started:{ _ in self.startOverlay() }, next: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
            .startWithNext { _ in self.muscleTableView.reloadData() }
        
        viewModel.exerciseNameInput <~ exerciseNameTextField.keyPress()
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonTouch(sender: AnyObject) {
        if viewModel.isValid() {
            dismissViewControllerAnimated(true, completion: onDone(name: exerciseNameTextField.text!, selectedMuscles: viewModel.getSelectedMuscles()))
        } else {
            alert("your form is incomplete! name must not be empty and you must select at least one muscle")
        }
    }
    
    func injectDependencies(dataStore: DataStore, onDone: (name: String, selectedMuscles: [Muscle]) -> () -> Void) {
        self.onDone = onDone
        self.viewModel = ExerciseFormViewModel(dataStore: dataStore)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMusclesnSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("muscleCell", forIndexPath: indexPath) as! SelectMuscleTableViewCell
        let muscle = viewModel.muscleGroupAtIndexPath(indexPath)
        
        cell.viewData = SelectMuscleTableViewCell.ViewData(muscle: muscle, onSelectMuscle: { muscle in self.viewModel.muscleSelected(muscle) })
        return cell
    }
}
