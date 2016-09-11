//
//  SelectExerciseTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SelectExerciseTableViewController: UITableViewController {
    
    private var onCancel: (() -> Void)?
    private var onSelect: ((Exercise, Int) -> Void)?
    private var selectedExercise : Exercise?
    private var viewModel: ExercisesViewModel!
    
    @IBAction func touchUpCancelButton(sender: AnyObject) {
        if let onCancel = onCancel {
            onCancel()
        }
    }
    
    func injectDependency(viewModel: ExercisesViewModel, onSelect: ((Exercise, Int) -> Void)?, onCancel: (() -> Void)?) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        self.onCancel = onCancel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshSignalProducer()
            .startOn(UIScheduler())
            .startWithNext({ _ in self.tableView.reloadData() })
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfExercisesInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let exercise = viewModel.exerciseAtIndexPath(indexPath)
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
        return cell
    }
    
    // MARK: - Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedExercise = viewModel.exerciseAtIndexPath(indexPath)
        performSegueWithIdentifier("ShowRepsModal", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch (segue.identifier!) {
        case "ShowRepsModal":
            if let vc = segue.destinationViewController as? SelectRepsViewController {
                vc.injectDependency(
                    10,
                    onCancel: { self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)  },
                    onDone: { reps in
                        self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)
                        self.onSelect!(self.selectedExercise!, reps)
                    }
                )
            }
        default:
            break
        }
    }
}
