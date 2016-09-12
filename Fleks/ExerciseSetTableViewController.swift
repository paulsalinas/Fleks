//
//  NewExerciseSetTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-02.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ExerciseSetTableViewController: UITableViewController {
    
    private enum TableCellTypes: String {
        case AddExerciseCell
        case SetsInputCell
        case NotesCell
        case ExerciseSetCell
    }
    
    @IBOutlet weak var notesTextField: UITextField!
    
    private var viewModel: ExerciseSetFormViewModel!
    private var exercisesViewModel: ExercisesViewModel!
    private var selectedIndexPath: NSIndexPath!
    private var onCancel: () -> Void = { Void() }
    
    func injectDependency(viewModel: ExerciseSetFormViewModel, exercisesViewModel: ExercisesViewModel, onCancel: () -> Void) {
        self.viewModel = viewModel
        self.exercisesViewModel = exercisesViewModel
        self.onCancel = onCancel
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshSignal
            .startOn(UIScheduler())
            .startWithNext { _ in self.tableView.reloadData() }
    }
    
    @IBAction func doneBtnTouchUp(sender: AnyObject) {
        viewModel.Complete()
    }
    
    @IBAction func cancelBtnTouchUp(sender: AnyObject) {
        onCancel()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSelectExerciseModal", let vc = segue.destinationViewController as? UINavigationController {
            guard let selectVC = vc.topViewController as? SelectExerciseTableViewController else {
                return
            }
            
            selectVC.injectDependency(
                self.exercisesViewModel,
                onSelect: { exercise, reps in
                    self.viewModel.addExercise(exercise, withReps: reps)
                    self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)
                },
                onCancel: { _ in self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil) }
            )
        } else if segue.identifier  == "ShowRepsModal", let vc = segue.destinationViewController as? SelectRepsViewController, let selectedIndexPath = selectedIndexPath {
            
            let selectedExerciseSet = viewModel.exerciseSetAtIndexPath(selectedIndexPath)
            
            vc.injectDependency(
                selectedExerciseSet.repetitions,
                onCancel: { self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil) },
                onDone: { reps in
                    self.viewModel.updateExercise(reps, indexPath: selectedIndexPath)
                    self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            )
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + viewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : viewModel.numberOfRowsInSection(section - 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // handle the top section case where we've placed the controls
        switch (indexPath.section) {
        case 0:
            
            switch(indexPath.row) {
            case 0:
                return tableView.dequeueReusableCellWithIdentifier(TableCellTypes.AddExerciseCell.rawValue)!
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier(TableCellTypes.SetsInputCell.rawValue) as! InputSetTableViewCell
                cell.viewData = InputSetTableViewCell.ViewData(initialValue: viewModel.numberOfSets.value)
                viewModel.numberOfSets <~ cell.setStepper.changeValue().producer.map { Int($0) }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier(TableCellTypes.NotesCell.rawValue) as! NotesInputTableViewCell
                viewModel.notes <~ cell.notesInputTextField.keyPress()
                return cell
            default:
                break
                
            }
            
        default:
            break
        }
        
        // handle the case for the exercise sets here
        let cell = tableView.dequeueReusableCellWithIdentifier(TableCellTypes.ExerciseSetCell.rawValue)!
        let indexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)
        let exerciseSet = viewModel.exerciseSetAtIndexPath(indexPath)
        cell.detailTextLabel!.text = String(exerciseSet.repetitions)
        cell.textLabel?.text = exerciseSet.exercise.name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return ""
        default:
            return viewModel.sectionTitle(section - 1)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            performSegueWithIdentifier("ShowSelectExerciseModal", sender: self)
        } else if indexPath.section > 0 {
            selectedIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)
            performSegueWithIdentifier("ShowRepsModal", sender: self)
        }
    }
    
}
