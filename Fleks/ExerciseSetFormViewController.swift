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
    @IBOutlet weak var notesTextField: UITextField!
    
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
        viewModel.notesInput <~ notesTextField.keyPress().map { $0 as String? }
    
        viewModel.isValidationErrorProducer
            .startWithNext(updateStateWithError)
    }
    
    func createMergedSignalProducer(textField textField: UITextField, stepper: UIStepper) -> SignalProducer<String, NoError> {
        let textProducer: SignalProducer<String, NoError> = textField.keyPress()
        let stepperProducer: SignalProducer<String, NoError> =  stepper.changeValue().map { String($0) }
        
        return SignalProducer(values: [textProducer, stepperProducer])
            .flatten(.Merge)
    }
    
    func updateStateWithError(validationError: (InvalidInputError, InvalidInputError)) {
        let (invalidReps, invalidSets) = validationError
        
        var combinedErrMsg = ""
        
        switch (invalidReps) {
            case .Invalid(let errMsg):
                combinedErrMsg = combinedErrMsg + errMsg + "\n"
                repsTextField.backgroundColor = errorColor
            case .None:
                repsTextField.backgroundColor = UIColor.whiteColor()
                break
        }
        
        switch (invalidSets) {
            case .Invalid(let errMsg):
                combinedErrMsg = combinedErrMsg + errMsg
                setsTextField.backgroundColor = errorColor
            case .None:
                setsTextField.backgroundColor = UIColor.whiteColor()
                break
        }
        
        if combinedErrMsg != "" {
            errorLabel.text = combinedErrMsg
            addExerciseBtn.enabled = false
        } else {
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
                notes: viewModel.notesInput.value ?? ""
            )
        )
    }
}