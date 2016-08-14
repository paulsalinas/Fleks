//
//  WorkoutTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController, ActivityOverlayable, Alertable {
    
    var activityOverlay: ActivityOverlay?
    
    enum SegueIdentifierTypes: String {
        case ShowWorkoutDetailSegue = "showWorkoutDetailSegue"
    }
    
    var dataSource: DataStore!
    private var viewModel: WorkoutViewModel!
    
    var selectedWorkout: Workout?
    
    func injectDependency(dataStore: DataStore) {
        self.viewModel = WorkoutViewModel(dataStore: dataStore)
    }
    
    @IBAction func addWorkoutButtonTouchUp(sender: AnyObject) {
        performSegueWithIdentifier(SegueIdentifierTypes.ShowWorkoutDetailSegue.rawValue, sender: self)
    }
    override func viewDidLoad() {
        viewModel.refreshSignalProducer()
            .on(started:{ _ in self.startOverlay() }, next: { _ in self.stopOverlay() }, failed: { _ in self.alert("Sorry! it's seems like there's an issue getting your data!") })
            .startWithNext { _ in self.tableView.reloadData() }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        selectedWorkout = nil
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedWorkout = viewModel.workoutAtIndexPath(indexPath)
        performSegueWithIdentifier(SegueIdentifierTypes.ShowWorkoutDetailSegue.rawValue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = SegueIdentifierTypes(rawValue: segue.identifier!) else {
            return
        }
        
        switch(id) {
            case .ShowWorkoutDetailSegue:
                if let destinationController = segue.destinationViewController as? ExerciseSetGroupTableViewController {
                    let tabBarVC = tabBarController as! FleksTabBarController
                    destinationController.injectDependency(tabBarVC.dataStore, workout: selectedWorkout)
                }
        }
    }
    
    // MARK: - DataSource
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfWorkoutsInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutCell", forIndexPath: indexPath)
        let workout = viewModel.workoutAtIndexPath(indexPath)
        cell.textLabel?.text = workout.name
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            viewModel.removeWorkoutAtIndexPath(indexPath).start()
        }
    }
}
