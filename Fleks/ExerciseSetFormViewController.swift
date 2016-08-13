//
//  ExerciseSetFormViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-22.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import Foundation

class ExerciseSetFormViewController: UIViewController {
    
    private var dataStore: DataStore!
    private var onSubmitUpdate: (reps: Int, sets: Int, notes: String) -> () -> Void = { _ in  { _ in  () } }
    
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsStepper: UIStepper!
    @IBOutlet weak var repsStepper: UIStepper!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextView!
    
    @IBOutlet weak var addExerciseBtn: UIButton!
    
    var viewModel: ExerciseSetViewModel!
    let errorColor = UIColor.redColor()
    
    func injectDependency(dataStore: DataStore, onSubmitUpdate: (reps: Int, sets: Int, notes: String) -> () -> Void ) {
        self.onSubmitUpdate = onSubmitUpdate
        self.viewModel = ExerciseSetViewModel(dataStore: dataStore)
    }
    
    func injectDependency(dataStore: DataStore, reps: Int, sets: Int, notes: String, onSubmitUpdate: (reps: Int, sets: Int, notes: String) -> () -> Void ) {
        self.onSubmitUpdate = onSubmitUpdate
        self.viewModel = ExerciseSetViewModel(dataStore: dataStore, reps: reps, sets: sets, notes: notes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.repsDisplayProducer
            .startWithNext { next in
                self.repsTextField.text = next
                self.repsStepper.value = Double(next) ?? 0
            }
        
        viewModel.setsDisplayProducer
            .startWithNext { next in
                self.setsTextField.text = next
                self.setsStepper.value = Double(next) ?? 0
            }
        
        let removeDecimalsIfAny: String -> String = { $0.containsString(".") ? $0.characters.split(".").map(String.init)[0] : $0 }
        
        viewModel.repsInput <~ createMergedSignalProducer(textField: repsTextField, stepper: repsStepper)
            .map(removeDecimalsIfAny)
        viewModel.setsInput <~ createMergedSignalProducer(textField: setsTextField, stepper: setsStepper)
            .map(removeDecimalsIfAny)
        
        notesTextField.text = viewModel.notesInput.value
        viewModel.notesInput <~ notesTextField.keyPress()
    
        viewModel.isValidationErrorProducer
            .startWithNext(updateStateWithError)
    }
    
    func createMergedSignalProducer(textField textField: UITextField, stepper: UIStepper) -> SignalProducer<String, NoError> {
        let textProducer: SignalProducer<String, NoError> = textField.keyPress()
        let stepperProducer: SignalProducer<String, NoError> =  stepper.changeValue().map { String($0) }
        
        return SignalProducer(values: [textProducer, stepperProducer])
            .flatten(.Merge)
    }
    
    func updateStateWithError(validationError: ExerciseSetFormError) {
        switch (validationError) {
            case .InvalidRep(let errMsg):
                repsTextField.backgroundColor = errorColor
                errorLabel.text = errMsg
                addExerciseBtn.enabled = false
            case .InvalidSet(let errMsg):
                setsTextField.backgroundColor = errorColor
                errorLabel.text = errMsg
                addExerciseBtn.enabled = false
            case .None:
                repsTextField.backgroundColor = UIColor.whiteColor()
                setsTextField.backgroundColor = UIColor.whiteColor()
                errorLabel.text = ""
                 addExerciseBtn.enabled = true
        }
    }
    
    @IBAction func touchUpAddExerciseBtn(sender: AnyObject) {
        dismissViewControllerAnimated(
            true,
            completion: onSubmitUpdate(
                reps: Int(viewModel.repsInput.value)!,
                sets: Int(viewModel.setsInput.value)!,
                notes: viewModel.notesInput.value
            )
        )
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowExerciseSetGroups" {
//            let vc = segue.destinationViewController as! ExerciseSetGroupTableViewController
//            let tabBar = tabBarController as! FleksTabBarController
//            vc.injectDependency(tabBar.createExerciseSetGroupViewModel(forWorkout: viewModel.workout))
//        }
//    }
    
}