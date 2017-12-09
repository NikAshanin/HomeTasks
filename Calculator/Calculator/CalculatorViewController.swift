import UIKit

final class CalculatorViewController: UIViewController {
    // MARK: properties
    private var engine = CalculatorEngine()
    private var returnedStack: (operand: Double?, operation: String?)
    private var buttonPressed = false
    let decimalSeparator = formatter.decimalSeparator ?? "."
    var userIsInTheMiddleOfTyping = false
    var doubleDisplayValue: Double? {
        get {
            if let text = display.text, let value = formatter.number(from: text) as? Double {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                display.text = formatter.string(from: NSNumber(value: value))
            }
        }
    }
    private var displayResult: (result: Double?, error: String?) = (nil, nil) {
        didSet {
            switch displayResult {
            case (nil, nil):
                doubleDisplayValue = 0
            case (let result, nil):
                doubleDisplayValue = result
            case (_, let error):
                display.text = error
            }
        }
    }

    // MARK: buttons
    @IBOutlet weak private var display: UILabel!
    @IBOutlet weak private var radDisplay: UILabel!
    @IBOutlet weak private var clearButton: RoundButton!
    @IBOutlet weak private var dot: RoundButton! {
        didSet {
            dot.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    @IBOutlet weak private var radButton: RoundButton!
    //Binary buttons
    @IBOutlet private var binaryBottons: [RoundButton]!
    //Buttoms for change
    @IBOutlet weak private var sinButton: RoundButton!
    @IBOutlet weak private var sinhButton: RoundButton!
    @IBOutlet weak private var cosButton: RoundButton!
    @IBOutlet weak private var coshButton: RoundButton!
    @IBOutlet weak private var tanButton: RoundButton!
    @IBOutlet weak private var tanhButton: RoundButton!
    @IBOutlet weak private var exponentInThePowerXButton: RoundButton!
    @IBOutlet weak private var lnButton: RoundButton!
    @IBOutlet weak private var tenInThePowerXButton: RoundButton!
    @IBOutlet weak private var logTenButton: RoundButton!

    // MARK: change buttoms signs
    @IBAction func pressSecondButtons(_ sender: RoundButton) {
        if sinButton.currentTitle == "sin" {
            sender.setTitleColor(UIColor.black, for: UIControlState())
            sender.layer.backgroundColor = #colorLiteral(red: 0.4083676934, green: 0.4083676934, blue: 0.4083676934, alpha: 1).cgColor
            sinButton.setTitle("sin⁻¹", for: UIControlState())
            sinhButton.setTitle("sinh⁻¹", for: UIControlState())
            cosButton.setTitle("cos⁻¹", for: UIControlState())
            coshButton.setTitle("cosh⁻¹", for: UIControlState())
            tanButton.setTitle("tan⁻¹", for: UIControlState())
            tanhButton.setTitle("tanh⁻¹", for: UIControlState())
            exponentInThePowerXButton.setTitle("yˣ", for: UIControlState())
            lnButton.setTitle("logᵧ", for: UIControlState())
            tenInThePowerXButton.setTitle("2ˣ", for: UIControlState())
            logTenButton.setTitle("log₂", for: UIControlState())
        } else {
            sender.setTitleColor(UIColor.white, for: UIControlState())
            sender.layer.backgroundColor = #colorLiteral(red: 0.1991537809, green: 0.1991537809, blue: 0.1991537809, alpha: 1).cgColor
            sinButton.setTitle("sin", for: UIControlState())
            sinhButton.setTitle("sinh", for: UIControlState())
            cosButton.setTitle("cos", for: UIControlState())
            coshButton.setTitle("cosh", for: UIControlState())
            tanButton.setTitle("tan", for: UIControlState())
            tanhButton.setTitle("tanh", for: UIControlState())
            exponentInThePowerXButton.setTitle("eˣ", for: UIControlState())
            lnButton.setTitle("ln", for: UIControlState())
            tenInThePowerXButton.setTitle("10ˣ", for: UIControlState())
            logTenButton.setTitle("log₁₀", for: UIControlState())
        }
    }

    // MARK: touch Rad button
    @IBAction func touchRadButton(_ sender: RoundButton) {
        if radDisplay.text == "" {
            radDisplay.text = " Rad"
            engine.changeMeasure(false)
            radButton.setTitle("Deg", for: UIControlState())
        } else {
            radDisplay.text = ""
            engine.changeMeasure(true)
            radButton.setTitle("Rad", for: UIControlState())
        }
    }

    // MARK: touch digit button
    @IBAction func touchDigit(_ sender: RoundButton) {
        guard let digit = sender.currentTitle, let textCurrentlyInDisplay = display.text else {
            return
        }
        if userIsInTheMiddleOfTyping {
            if (digit != decimalSeparator) || !(textCurrentlyInDisplay.contains(decimalSeparator)) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
            clearButton.setTitle("C", for: UIControlState())
            if digit != "0" {
                if digit == "." {
                    display.text = "0."
                }
                userIsInTheMiddleOfTyping = true
            }
        }
    }

    // MARK: touch arithmetic button
    @IBAction func touchMathAction(_ sender: RoundButton) {
        if let value = doubleDisplayValue {
            engine.setOperand(value)
            if userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfTyping = false
            }
        }
        if let mathExpression = sender.currentTitle {
            if buttonPressed {
                if let operation = returnedStack.operation {
                    changeButtonColor(operation, false)
                    engine.performOperation(operation)
                    displayResult = engine.result
                }
            }
            engine.operationIsSelected = false
            engine.performOperation(mathExpression)
            displayResult = engine.result
        }
    }

    // MARK: touch undo button
    @IBAction func touchUndo(_ sender: RoundButton) {
        if buttonPressed {
            if let operation = returnedStack.operation {
                changeButtonColor(operation, false)
            }
        }
        returnedStack = engine.undo()
        if returnedStack.operation == nil {
            returnedStack = engine.undo()
        }
        if let operation = returnedStack.operation {
            changeButtonColor(operation, true)
        }
        doubleDisplayValue = returnedStack.operand
        userIsInTheMiddleOfTyping = false
    }

    // MARK: touch redo button
    @IBAction func touchRedo(_ sender: RoundButton) {
        if buttonPressed {
            if let operation = returnedStack.operation {
                changeButtonColor(operation, false)
            }
        }
        returnedStack = engine.redo()
        if returnedStack.operand != nil {
            if let operation = returnedStack.operation {
                changeButtonColor(operation, true)
            }
            if let operand = returnedStack.operand {
                doubleDisplayValue = operand
                engine.setOperand(operand)
            }
            userIsInTheMiddleOfTyping = false
        }
    }

    // MARK: touch AC button
    @IBAction func allClear(_ sender: RoundButton) {
        if clearButton.currentTitle == "C" {
            clearSymbol()
            clearButton.setTitle("AC", for: UIControlState())
        } else {
            if buttonPressed {
                if let operation = returnedStack.operation {
                    changeButtonColor(operation, false)
                }
                buttonPressed = false
            }
            engine.clear()
            displayResult = (nil, nil)
            returnedStack = (nil, nil)
            userIsInTheMiddleOfTyping = false
        }
    }

    //Clear current display value
    private func clearSymbol() {
        guard display.text != nil else {
            return
        }
        userIsInTheMiddleOfTyping = false
        displayResult = (nil, nil)
    }

    //Set or reset background color on binary operation button
    private func changeButtonColor(_ operation: String, _ set: Bool) {
        for i in 0...binaryBottons.count - 1 where binaryBottons[i].currentTitle == operation {
                if binaryBottons[i].currentTitle == "xʸ" ||
                    binaryBottons[i].currentTitle == "ʸ√x" ||
                    binaryBottons[i].currentTitle == "yˣ" ||
                    binaryBottons[i].currentTitle == "logᵧ" {
                    if set {
                        binaryBottons[i].setTitleColor(UIColor.black, for: UIControlState())
                        binaryBottons[i].layer.backgroundColor = #colorLiteral(red: 0.4083676934, green: 0.4083676934, blue: 0.4083676934, alpha: 1).cgColor
                        buttonPressed = true
                        engine.operationIsSelected = true
                    } else {
                        binaryBottons[i].setTitleColor(UIColor.white, for: UIControlState())
                        binaryBottons[i].layer.backgroundColor = #colorLiteral(red: 0.1991537809, green: 0.1991537809, blue: 0.1991537809, alpha: 1).cgColor
                        buttonPressed = false
                    }
                } else {
                    if set {
                        binaryBottons[i].setTitleColor(UIColor.orange, for: UIControlState())
                        binaryBottons[i].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                        buttonPressed = true
                        engine.operationIsSelected = true
                    } else {
                        binaryBottons[i].setTitleColor(UIColor.white, for: UIControlState())
                        binaryBottons[i].layer.backgroundColor = #colorLiteral(red: 1, green: 0.5846475959, blue: 0, alpha: 1).cgColor
                        buttonPressed = false
                    }
                }

        }
    }
}
