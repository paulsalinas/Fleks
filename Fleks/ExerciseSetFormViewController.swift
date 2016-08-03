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

    @IBOutlet weak var resistanceTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var resistanceStepper: UIStepper!
    @IBOutlet weak var setsStepper: UIStepper!
    @IBOutlet weak var repsStepper: UIStepper!
    
    var viewModel: ExerciseSetViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ExerciseSetViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.repsDisplay
            .startWithNext { next in
                self.repsTextField.text = next
                self.repsStepper.value = Double(next) ?? 0
            }
        
        viewModel.setsDisplay
            .startWithNext { next in
                self.setsTextField.text = next
                self.setsStepper.value = Double(next) ?? 0
            }
        
        viewModel.resistanceDisplay
            .startWithNext { next in
                self.resistanceTextField.text = next
                self.resistanceStepper.value = Double(next) ?? 0
            }
        
        let removeDecimalsIfAny: String -> String = { $0.containsString(".") ? $0.characters.split(".").map(String.init)[0] : $0 }
        
        viewModel.reps <~ createMergedSignalProducer(textField: repsTextField, stepper: repsStepper)
            .map(removeDecimalsIfAny)
        viewModel.sets <~ createMergedSignalProducer(textField: setsTextField, stepper: setsStepper)
            .map(removeDecimalsIfAny)
        
        viewModel.resistance <~ createMergedSignalProducer(textField: resistanceTextField, stepper: resistanceStepper)

    }
    
    func createMergedSignalProducer(textField textField: UITextField, stepper: UIStepper) -> SignalProducer<String, NoError> {
        let textProducer: SignalProducer<String, NoError> = textField.keyPress()
        let stepperProducer: SignalProducer<String, NoError> =  stepper.changeValue().map { String($0) }
        
        return SignalProducer(values: [textProducer, stepperProducer])
            .flatten(.Merge)
    }
    
}