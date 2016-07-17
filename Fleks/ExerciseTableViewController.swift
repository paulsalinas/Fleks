//
//  ExerciseTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: ExerciseDataSource!
    private var viewModel: ExerciseViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ExerciseDataSource(cellReuseIdentifier: "cell", viewModel: viewModel, tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
    }
    
    func injectDependency(viewModel: ExerciseViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func unwindFromAddController(segue: AddExerciseCompletionSegue) {
        viewModel.createExercise(segue.exerciseNameText, muscles: segue.selectedMuscles)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddExerciseSegue" ) {
            let addExerciseController = segue.destinationViewController as! AddExerciseViewController
            addExerciseController.injectDependencies(viewModel)
        }
    }
}
