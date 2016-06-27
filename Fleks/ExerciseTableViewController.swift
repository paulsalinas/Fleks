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
    private var dataManager: ExerciseFirebaseDataManager!
    
    var client: FirebaseClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = ExerciseFirebaseDataManager(firebaseClient: client)
        dataSource = ExerciseDataSource(cellReuseIdentifier: "cell", exerciseDataManager: dataManager, tableView: tableView)
        dataManager.delegate = dataSource
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.allowsSelection = false
    }
    
    @IBAction func unwindFromAddController(segue: AddExerciseCompletionSegue) {
        // dataManager.createExercise(segue.exerciseNameText, muscles: segue.selectedMuscles)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddExerciseSegue" ) {
            let addExerciseController = segue.destinationViewController as! AddExerciseViewController
            addExerciseController.client = client
        }
    }

}
