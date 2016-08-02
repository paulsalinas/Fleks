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
    
    private let decimalTextViewDelegate = DecimalTextFieldDelegate()
    private let integerTextViewDelegate = IntegerTextViewDelegate()
    
    @IBAction func setsStepperOnValueChanged(sender: AnyObject) {
        let stepper = sender as! UIStepper
        setsTextField.text = String(Int(stepper.value))
    }
    
    let reps: MutableProperty<Int> = MutableProperty(10)
    let sets: MutableProperty<Int> = MutableProperty(4)
    let resistance: MutableProperty<String?> = MutableProperty(String(20))
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setsTextField.delegate = integerTextViewDelegate
        repsTextField.delegate = integerTextViewDelegate
        resistanceTextField.delegate = decimalTextViewDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reps.producer
            .startWithNext { next in
                self.repsTextField.text = String(next)
                self.repsStepper.value = Double(next)
            }
        
        sets.producer
            .startWithNext { next in
                self.setsTextField.text = String(next)
                self.setsStepper.value = Double(next)
            }
        
        resistance.producer
            .startWithNext { next in
                if let next = next  {
                    self.resistanceTextField.text = String(next)
                    self.resistanceStepper.value = Double(next) ?? 0
                }
            }
        
        reps <~ createMergedSignalProducer(textField: repsTextField, stepper: repsStepper)
            .map { Int($0) ?? 0 }
        
        sets <~ createMergedSignalProducer(textField: setsTextField, stepper: setsStepper)
            .map { Int($0) ?? 0 }
        
        resistance <~ createMergedSignalProducer(textField: resistanceTextField, stepper: resistanceStepper)
            .map { val in
                if Double(val) != nil {
                    return val
                } else {
                    return nil
                }
            }
    }
    
    func createMergedSignalProducer(textField textField: UITextField, stepper: UIStepper) -> SignalProducer<String, NoError> {
        let textProducer: SignalProducer<String, NoError> = textField.keyPress()
        let stepperProducer: SignalProducer<String, NoError> =  stepper.changeValue().map { String($0) }
        
        return SignalProducer(values: [textProducer, stepperProducer])
            .flatten(.Merge)
    }
    
}