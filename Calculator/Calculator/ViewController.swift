//
//  ViewController.swift
//  calc
//
//  Created by Sergey Gusev on 29.10.2017.
//  Copyright © 2017 Sergey Gusev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var displayRadDeg: UILabel!
    @IBOutlet private weak var firstRow1: UIButton!
    @IBOutlet private weak var firstRow2: UIButton!
    @IBOutlet private weak var secondRow1: UIButton!
    @IBOutlet private weak var secondRow2: UIButton!
    @IBOutlet private weak var thirdRow1: UIButton!
    @IBOutlet private weak var thirdRow2: UIButton!
    @IBOutlet private weak var thirdRow3: UIButton!
    @IBOutlet private weak var fourthRow1: UIButton!
    @IBOutlet private weak var fourthRow2: UIButton!
    @IBOutlet private weak var fourthRow3: UIButton!
    @IBOutlet private weak var clearButton: UIButton!
    var userIsInTheMiddleOfTyping = false
    var chooseTheDot = false
    // var index = 1;
    var indexOfSecondbutton = false
    let decimalSeparator = formatter.decimalSeparator ?? "."
    var bufferOperand = 0.0
    lazy var arrayUndoRedo:[String] = []
    lazy var supportUndoRedo:[UndoRedo] = []
    public enum UndoRedo {
        case operation
        case number
    }
    let labelRadDeg = [
        "Rad": "Deg",
        "Deg": "Rad"
    ]
    var secondButtonDictionary = [
        "eˣ": "yˣ",
        "10ˣ": "2ˣ",
        "ln": "logᵧ",
        "log₁₀": "log₂",
        "sin": "sin⁻¹",
        "cos": "cos⁻¹",
        "tan": "tan⁻¹",
        "sinh": "sinh⁻¹",
        "cosh": "cosh⁻¹",
        "tanh": "tanh⁻¹",
        "yˣ": "eˣ",
        "2ˣ": "10ˣ",
        "logᵧ": "ln",
        "log₂": "log₁₀",
        "sin⁻¹": "sin",
        "cos⁻¹": "cos",
        "tan⁻¹": "tan",
        "sinh⁻¹": "sinh",
        "cosh⁻¹": "cosh",
        "tanh⁻¹": "tanh"
    ]
    lazy var arrayButton: [UIButton] = [firstRow1, firstRow2, secondRow1, secondRow2, thirdRow1, thirdRow2, thirdRow3, fourthRow1, fourthRow2, fourthRow3]
    @IBAction func clearAll(_ sender: UIButton) {
        brain.clear()
        displayValue = 0
        userIsInTheMiddleOfTyping = false
        chooseTheDot = false
        indexOfSecondbutton = false
        sender.setTitle("AC", for: .normal)
        arrayUndoRedo.removeAll()
    }
    @IBAction func changeButton(_ sender: UIButton) {
        for item in arrayButton {
            if let buttonTitle = secondButtonDictionary[item.currentTitle!] {
                item.setTitle(buttonTitle, for: .normal)
            }
            print(item)
        }
    }
    @IBAction func touchDigit(_ sender: UIButton) {
        clearButton.setTitle("C", for: .normal)
        let digit = sender.currentTitle!
        if digit == "." {
            if chooseTheDot == true {
                return
            }
            chooseTheDot = true
        }
        print("\(digit) pressed")
        if digit == "0" && userIsInTheMiddleOfTyping == false {
            return
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text! = textCurrentlyInDisplay + digit
        } else {
            if digit == "." {
                display.text! = "0" + digit
                userIsInTheMiddleOfTyping = true
            } else {
                display.text! = digit
                userIsInTheMiddleOfTyping = true
            }
        }
    }
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            switch String(newValue) {
            case let z where z.hasSuffix(".0"):
                display.text = " " + String(Int64(newValue))
            default: display.text = " " + String(Double(newValue))
            }
        }
    }
    private var brain = CalculatorBrain()
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            //bufferOperand = displayValue
            //arrayUndoRedo.append(displayValue)
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.perfomOperation(mathematicalSymbol)
            arrayUndoRedo.append(display.text!)
            supportUndoRedo.append(.number)
            if mathematicalSymbol != "=" {
                arrayUndoRedo.append(mathematicalSymbol)
                supportUndoRedo.append(.operation)
            }
        }
        if let result = brain.result {
            displayValue = result
            //arrayUndoRedo.append(result)
        }
        chooseTheDot = false
    }
    @IBAction func changeRadDeg(_ sender: UIButton) {
        if let buttonTitleOfRadDeg = labelRadDeg[sender.currentTitle!] {
            sender.setTitle(buttonTitleOfRadDeg, for: .normal)
        }
        if sender.currentTitle! == "Deg" {
            displayRadDeg.text! = "Rad"
            brain.setIsRadian(true)
        } else {
            displayRadDeg.text! = " "
            brain.setIsRadian(false)
        }
    }
    @IBAction func doUndoRedo(_ sender: UIButton) {
        print(arrayUndoRedo)
        print(supportUndoRedo)
        guard let undoVariable = arrayUndoRedo.popLast() else {
            return
        }
    }
}
