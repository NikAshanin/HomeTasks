import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet private weak var resultLabel: UILabel!
    public var stack = Stack()
    public var symbol = ""
    public var delete = false
    public var blockAppendingToStack = false
    public var beginWork = false
    public var calculatorService = CalculatorService()
    public var flagSecondMode = false
    var displayValue: Double {
        get {
            return Double(resultLabel.text ?? "") ?? 0
        }
        set {
            resultLabel.text = String(newValue)
            if calculatorService.flagForStack, !blockAppendingToStack {
                stack.insert(newValue)
            }
        }
    }

    @IBAction private func buttonPressed(_ sender: UIButton) {
        let digit = sender.currentTitle ?? ""
        if beginWork {
            let textOnDisplay = resultLabel.text ?? ""
            resultLabel.text = textOnDisplay + digit
        } else {
            resultLabel.text = digit
            beginWork = true
        }
    }
    @IBAction private func clearDisplay(_ sender: UIButton) {
        calculatorService.reset()
        resultLabel.text? = "0"
        beginWork = false
    }
    @IBAction private func decimal(_ sender: UIButton) {
        if !beginWork {
            resultLabel.text? = "0."
            beginWork = true
        } else if !(resultLabel.text?.contains(".") ?? true) {
            resultLabel.text? += "."
        }
    }
    @IBAction private func operationWithDigit(_ sender: UIButton) {
        if beginWork {
            calculatorService.setOperand(displayValue)
            if symbol != "" {
                calculatorService.performOperation(symbol)
            }
            beginWork = false
            if blockAppendingToStack == false {
                stack.insert(displayValue)
            }
        }
        if delete {
            stack.remove(from: stack.currentIndex)
        }
        if let mathSymbol = sender.currentTitle {
            calculatorService.performOperation(mathSymbol)
            if mathSymbol != "=", !blockAppendingToStack {
                stack.insert(mathSymbol)
                stack.remove(from: stack.currentIndex)
            }
        }
        if let result = calculatorService.result {
            displayValue = result
        }
    }
    @IBAction private func backButton(_ sender: Any) {
        delete = false
        blockAppendingToStack = true
        if stack.currentIndex != 0 {
            stack.currentIndex -= 1
            calculatorService.reset()
            calculatorService.setOperand(stack.returnDigitFromArray())
            displayValue = stack.returnDigitFromArray()
            let operand = displayValue
            if operand == 0 {
                symbol = stack.currentElement
                delete = true
            }
        }
        symbol = ""
        blockAppendingToStack = false
    }
    @IBAction private func forwardButton(_ sender: Any) {
        delete = false
        blockAppendingToStack = true
        if stack.currentIndex < stack.arrayNumber.count - 1 {
            stack.currentIndex += 1
            calculatorService.reset()
            calculatorService.setOperand(stack.returnDigitFromArray())
            displayValue = stack.returnDigitFromArray()
            let operand = displayValue
            if operand == 0 {
                symbol = stack.currentElement
                delete = true
            }
        }
        blockAppendingToStack = false
        symbol = ""
    }
    @IBAction private func showStack(_ sender: Any) {
        print(stack.arrayNumber)
    }

    @IBOutlet private weak var radianStatusLabel: UILabel!
    @IBOutlet private weak var radianDegreeLabel: UIButton!

    @IBAction private func setRadian(_ sender: Any) {
        if radianStatusLabel.isHidden == true {
            radianStatusLabel.isHidden = false
            radianDegreeLabel.setTitle("Deg", for: .normal)
            calculatorService.isRadian = true
        } else {
            radianStatusLabel.isHidden = true
            radianDegreeLabel.setTitle("Rad", for: .normal)
            calculatorService.isRadian = false
        }
    }

    @IBOutlet private weak var sinButton: UIButton!
    @IBOutlet private weak var sinHButton: UIButton!
    @IBOutlet private weak var cosButton: UIButton!
    @IBOutlet private weak var cosHButton: UIButton!
    @IBOutlet private weak var tanButton: UIButton!
    @IBOutlet private weak var tanHButton: UIButton!
    @IBOutlet private weak var exButton: UIButton!
    @IBOutlet private weak var lnButton: UIButton!
    @IBOutlet private weak var tenXButton: UIButton!
    @IBOutlet private weak var log10Button: UIButton!

    @IBAction private func secondMode(_ sender: Any) {
        if flagSecondMode == true {
            sinHButton.setTitle("sinh^-1", for: .normal)
            sinButton.setTitle("sin^-1", for: .normal)
            cosButton.setTitle("cos^-1", for: .normal)
            cosHButton.setTitle("cosh^-1", for: .normal)
            tanButton.setTitle("tan^-1", for: .normal)
            tanHButton.setTitle("tanh^-1", for: .normal)
            exButton.setTitle("y^x", for: .normal)
            tenXButton.setTitle("2^x", for: .normal)
            lnButton.setTitle("logx", for: .normal)
            log10Button.setTitle("log2", for: .normal)
            flagSecondMode = false
        } else {
            sinHButton.setTitle("sinh", for: .normal)
            sinButton.setTitle("sin", for: .normal)
            cosButton.setTitle("cos", for: .normal)
            cosHButton.setTitle("cosh", for: .normal)
            tanButton.setTitle("tan", for: .normal)
            tanHButton.setTitle("tanh", for: .normal)
            exButton.setTitle("e^x", for: .normal)
            tenXButton.setTitle("10^x", for: .normal)
            lnButton.setTitle("ln", for: .normal)
            log10Button.setTitle("log10", for: .normal)
            flagSecondMode = true
        }
    }
}
extension String {
    func isNumber() -> Bool {
        return Double(self) != nil ? true : false
    }
}
