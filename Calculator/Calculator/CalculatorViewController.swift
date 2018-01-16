import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet private weak var radian: UILabel!
    @IBOutlet private var operationButtons: [UIButton]!
    @IBOutlet private var changeOperandsButtons: [UIButton]!
    @IBOutlet private weak var resultField: UILabel!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private var allOperations: [UIButton]!
    private var newNumber = true
    private var notPressed = false
    private var clearAll = false

    func changeStep(value: String) {
        if Double(value) != nil {
            if notPressed {
                for operand in allOperations {
                    operand.isHighlighted = false
                }
                notPressed = false
            } else {
                notPressed = true
            }
            resultField.text = value
        } else {
            notPressed = true
            for operand in allOperations where operand.titleLabel?.text == value {
                operand.isHighlighted = true
            }
        }
    }

    @IBAction func undoButtonPressed(_ sender: Any) {
        let value = Calculator.undo()
        changeStep(value: value)
    }

    @IBAction func redoButtonPressed(_ sender: Any) {
        let value = Calculator.redo()
        changeStep(value: value)
    }

    @IBAction func digitButtonPressed(_ sender: UIButton) {
        if newNumber {
            clearButton.setTitle("C", for: .normal)
            resultField.text = ""
            newNumber = false
        }
        // swiftlint:disable:next force_unwrapping
        resultField.text! += sender.titleLabel?.text ?? ""
    }

    @IBAction func operandButtonPressed(_ sender: UIButton) {
        resultField.text = Calculator.calculate(inputNumber: resultField.text,
                                                operationValue: sender.titleLabel?.text ?? "")
        newNumber = true
        clearAll = false
    }

    @IBAction func resultButtonPressed(_ sender: UIButton) {
        resultField.text = Calculator.result(value: resultField.text)
        newNumber = true
    }

    @IBAction func constantButtonPressed(_ sender: UIButton) {
        resultField.text = Calculator.constantClick(operand: sender.titleLabel?.text ?? "")
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        Calculator.clearResult(clear: clearAll)
        clearButton.setTitle("AC", for: .normal)
        resultField.text = String(0)
        newNumber = true
        clearAll = true
    }

    @IBAction func showBorderOnTap(sender: UIButton) {
        for button in self.operationButtons {
            button.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.gray.cgColor
    }

    @IBAction func radianOrDegreeButtonPressed(sender: UIButton) {
        let buttonValue = sender.titleLabel?.text ?? ""
        switch buttonValue {
        case "Rad":
            Calculator.setRadian()
            radian.isHidden = false
            sender.setTitle("Deg", for: .normal)
        case "Deg":
            Calculator.setDegree()
            radian.isHidden = true
            sender.setTitle("Rad", for: .normal)
        default: break
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    @IBAction func changeOperands() {
        for button in self.changeOperandsButtons {
            let buttonValue = button.titleLabel?.text ?? ""
            switch buttonValue {
            case "sin", "cos", "tan", "sinh", "cosh", "tanh":
                button.setTitle(buttonValue + "-1", for: .normal)
            case "sin-1", "cos-1", "tan-1", "sinh-1", "cosh-1", "tanh-1":
                let range = buttonValue.startIndex..<buttonValue.index(buttonValue.endIndex, offsetBy: -2)
                button.setTitle(String(buttonValue[range]), for: .normal)
            case "10 ̽":
                button.setTitle("2 ̽", for: .normal)
            case "2 ̽":
                button.setTitle("10 ̽", for: .normal)
            case "log10":
                button.setTitle("log2", for: .normal)
            case "log2":
                button.setTitle("log10", for: .normal)
            case "e ̽":
                button.setTitle("y ̽", for: .normal)
            case "y ̽":
                button.setTitle("e ̽", for: .normal)
            case "ln":
                button.setTitle("logy", for: .normal)
            case "logy":
                button.setTitle("ln", for: .normal)
            default: break
            }
        }
    }
}
