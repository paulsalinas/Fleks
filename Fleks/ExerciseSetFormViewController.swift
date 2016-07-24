//
//  ExerciseSetFormViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-22.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ExerciseSetFormViewController: UIViewController {
    
    private var exerciseSet: ExerciseSet! {
        didSet {
            repsTextField.text = String(exerciseSet.repetitions)
            resistanceTextField.text = String(exerciseSet.resistance)
            repsStepper.value = Double(exerciseSet.repetitions)
            resistanceStepper.value = Double(exerciseSet.resistance)
        }
    }

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
    
    var textFieldStepperMapping: [UITextField: UIStepper]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set defaults
        exerciseSet = ExerciseSet(order: 1, repetitions: 10, resistance: 20, exercise: Exercise(id: "", name: "", muscles: [Muscle]()), notes: "")
    
        setsTextField.delegate = integerTextViewDelegate
        repsTextField.delegate = integerTextViewDelegate
        resistanceTextField.delegate = decimalTextViewDelegate
        
        textFieldStepperMapping = [
            setsTextField: setsStepper,
            repsTextField: repsStepper,
            resistanceTextField: repsStepper
        ]
        
        setsTextField.addTarget(self, action: #selector(ExerciseSetFormViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(textField: UITextField){
        print("Hi")
    }
}