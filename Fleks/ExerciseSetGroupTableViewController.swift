//
//  ExerciseSetGroupTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-09.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import Foundation

class ExerciseSetGroupTableViewController: UITableViewController, ActivityOverlayable, Alertable {
    
    var activityOverlay: ActivityOverlay?
    
    enum SegueIdentifierTypes: String {
        case EditExerciseSetGroupSegue = "EditExerciseSetGroupSegue"
        case ShowSelectExerciseModally = "ShowSelectExerciseModally"
    }
    
    enum CellTypes: String {
        case Header = "exerciseSetGroupTableHeader"
        case Normal = "exerciseSetGroupCell"
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private var viewModel: ExerciseSetGroupsViewModel!
    private var dataStore: DataStore!
    private var workoutId: String?
    private var selectedExerciseSetGroup: ExerciseSetGroup?
    
    override func viewDidLoad() {
        tableView.allowsMultipleSelectionDuringEditing = false;
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
        super.viewWillAppear(animated)
    }
    
    func refresh() {
        let tableObserver = Observer<Void, NSError>.init(next: { _ in self.tableView.reloadData() })
        let nameInputObserver = Observer<Void, NSError>.init(next: { _ in
            
            // initialize the header with the form to edit the workout name
            if let cell = self.tableView.dequeueReusableCellWithIdentifier(CellTypes.Header.rawValue) as? ExerciseSetGroupHeaderTableViewCell {
                cell.contentView.backgroundColor = UIColor.clearColor()
                self.tableView.tableHeaderView = cell.contentView
                self.viewModel.workoutNameInput
                    .producer
                    .take(1)
                    .startWithNext { next in
                        if let next = next {
                            cell.workoutNameTextField!.text = next
                        }
                }
                
                self.viewModel.workoutNameInput <~ cell.workoutNameTextField.keyPress().map { $0 as String? }
            }
        })

        viewModel
            .refreshSignalProducer()
            .startOn(UIScheduler())
            .on(started:{ _ in self.startOverlay() }, next: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
            .startWithSignal { signal, _ in
                signal.observe(tableObserver) // constantly listen for table data changes
                signal.take(1).observe(nameInputObserver) // only initialize name text
            }
    }
    
    func injectDependency(dataStore: DataStore, workout: Workout?) {
        self.dataStore = dataStore
        self.viewModel = ExerciseSetGroupsViewModel(dataStore: dataStore, workoutId: workout?.id)
    }

    @IBAction func addButtonTouch(sender: AnyObject) {
        if viewModel.workoutNameInput.value == nil || viewModel.workoutNameInput.value == "" {
            alert("your workout needs a name!")
            return
        }
        
        performSegueWithIdentifier(SegueIdentifierTypes.ShowSelectExerciseModally.rawValue, sender: self)
    }
    
    @IBAction func editButtonTouch(sender: AnyObject) {
        if tableView.editing {
            editButton.title = "Edit"
            setEditing(false, animated: true)
        } else {
            editButton.title = "Done"
            setEditing(true, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = SegueIdentifierTypes(rawValue: segue.identifier!) else {
            return
        }
        
        switch(id) {
            case .ShowSelectExerciseModally:
                let vc = (segue.destinationViewController as! UINavigationController).topViewController as! SelectExercisesTableViewController
                
                if viewModel.doesWorkoutExist() {
                    vc.injectDependency(dataStore, onSubmitUpdate: { selectedExercise, reps, sets, notes in
                        return { _ in
                            self.viewModel.addExerciseSetGroup(withExercise: selectedExercise, reps: reps, sets: sets, notes: notes)
                                .on(started:{ _ in self.startOverlay() }, completed: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
                                .start()
                        }
                    })
                } else {
                    vc.injectDependency(dataStore, onSubmitUpdate: { selectedExercise, reps, sets, notes in
                        return { _ in
                            self.viewModel
                                .createWorkout(self.viewModel.workoutNameInput.value!, firstExercise: selectedExercise, reps: reps, sets: sets, notes: notes)
                                .on(started:{ _ in self.startOverlay() }, completed: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
                                .startWithCompleted { self.refresh() } // the refresh needs to be synchronous - needs to follow exactly after workout is created
                        }
                    })
                }
            
            case .EditExerciseSetGroupSegue:
                if let selectedExerciseSetGroup = selectedExerciseSetGroup,
                    let vc = segue.destinationViewController as? ExerciseSetFormViewController {
                    let sets = selectedExerciseSetGroup.sets.count
                    let reps = selectedExerciseSetGroup.sets.first!.repetitions
                    vc.injectDependency(
                        dataStore,
                        reps: reps,
                        sets: sets,
                        notes: selectedExerciseSetGroup.notes, onSubmitUpdate: { reps, sets, notes in
                            return { _ in
                                self.viewModel.updateExerciseSetGroup(
                                        selectedExerciseSetGroup,
                                        withReps: reps,
                                        withSets: sets,
                                        withNotes: notes
                                    )
                                    .on(started:{ _ in self.startOverlay() }, completed: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
                                    .start()
                            }
                        }
                    )
                }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfExerciseGroupsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellTypes.Normal.rawValue, forIndexPath: indexPath) as! ExerciseSetGroupTableViewCell
        let exerciseSetGroup = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        cell.viewData = ExerciseSetGroupTableViewCell.ViewData(exerciseSetGroup: exerciseSetGroup, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedExerciseSetGroup = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        performSegueWithIdentifier(SegueIdentifierTypes.EditExerciseSetGroupSegue.rawValue, sender: self)
    }
    
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        viewModel.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath).start()
     }
    
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
         if editingStyle == .Delete {
            viewModel.deleteExerciseSetGroupAtIndexPath(indexPath).start()
         }
     }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
}
