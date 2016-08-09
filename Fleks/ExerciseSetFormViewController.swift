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

    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsStepper: UIStepper!
    @IBOutlet weak var repsStepper: UIStepper!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: ExerciseSetViewModel!
    let errorColor = UIColor.redColor()
    
    func injectDependency(viewModel: ExerciseSetViewModel) {
        self.viewModel = viewModel
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
            case .InvalidSet(let errMsg):
                setsTextField.backgroundColor = errorColor
                errorLabel.text = errMsg
            case .None:
                repsTextField.backgroundColor = UIColor.whiteColor()
                setsTextField.backgroundColor = UIColor.whiteColor()
                errorLabel.text = ""
        }
    }
}