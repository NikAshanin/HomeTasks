import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet private weak var resultLabel: UILabel!
    var stack = Stack<String>()
    public var beginWork = false
    public var calculationModule = CalculationModule()
    public var flagSecondMode = false
    var displayValue: Double {
        get {
            return Double(resultLabel.text ?? "") ?? 0
        }
        set {
            resultLabel.text = String(newValue)
        }
    }

    @IBAction private func buttonPressed(_ sender: UIButton) {
        let digit = sender.currentTitle ?? ""
        if beginWork {
            let textOnDisplay = resultLabel.text ?? ""
            resultLabel.text = textOnDisplay + String(describing: digit)
        } else {
            resultLabel.text = digit
            beginWork = true
        }
    }

    @IBAction private func clearDisplay(_ sender: UIButton) {
        calculationModule.reset()
        resultLabel?.text = "0"
        beginWork = false
    }

    @IBAction private func decimal(_ sender: UIButton) {
        guard let textLabel = resultLabel?.text else {
            return
        }
        if !beginWork {
            resultLabel?.text = "0."
            beginWork = true
        } else if !textLabel.contains(".") {
            resultLabel?.text = textLabel + "."
        }
    }

    @IBAction private func operationWithDigit(_ sender: UIButton) {
        if beginWork {
            calculationModule.setOperand(displayValue)
            beginWork = false
            stack.push(String(displayValue))
        }

        if let mathSymbol = sender.currentTitle {
            calculationModule.performOperation(mathSymbol)
            if mathSymbol != "=" {
                stack.push(String(mathSymbol))
            }
        }
        if let result = calculationModule.result {
            displayValue = result
        }
    }
    @IBAction private func backButton(_ sender: Any) {
        let futureValue = stack.pop() ?? ""
        if futureValue == "" {
            return
        }
        if futureValue.isNumber() {
            displayValue = Double(futureValue) ?? 0
        } else {
            calculationModule.setOperand(Double(futureValue) ?? 0)
        }
    }

    @IBAction private func forwardButton(_ sender: Any) {
        let previousValue = stack.unPop() ?? ""
        if previousValue == "" {
            return
        }

        if previousValue.isNumber() {
            displayValue = Double(previousValue) ?? 0
        } else {
            calculationModule.setOperand(Double(previousValue) ?? 0)
        }
    }
    @IBAction private func clearStack(_ sender: Any) {
        print( "clearStack")
    }

    @IBOutlet private weak var radianStatusLabel: UILabel!
    @IBOutlet private weak var radianDegreeLabel: UIButton!
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

    @IBAction private func secondMode( _ sender: Any) {
        if flagSecondMode == true {
            sinHButton.setTitle( "sinh^-1", for: .normal)
            sinButton.setTitle( "sin^-1", for: .normal)
            cosButton.setTitle( "cos^-1", for: .normal)
            cosHButton.setTitle( "cosh^-1", for: .normal)
            tanButton.setTitle( "tan^-1", for: .normal)
            tanHButton.setTitle( "tanh^-1", for: .normal)
            exButton.setTitle( "y^x", for: .normal)
            tenXButton.setTitle( "2^x", for: .normal)
            lnButton.setTitle( "logx", for: .normal)
            log10Button.setTitle( "log2", for: .normal)
            flagSecondMode = false
        } else {
            sinHButton.setTitle( "sinh", for: .normal)
            sinButton.setTitle( "sin", for: .normal)
            cosButton.setTitle( "cos", for: .normal)
            cosHButton.setTitle( "cosh", for: .normal)
            tanButton.setTitle( "tan", for: .normal)
            tanHButton.setTitle( "tanh", for: .normal)
            exButton.setTitle( "e^x", for: .normal)
            tenXButton.setTitle( "10^x", for: .normal)
            lnButton.setTitle( "ln", for: .normal)
            log10Button.setTitle( "log10", for: .normal)
            flagSecondMode = true
        }
    }

    @IBAction private func setRadian( _ sender: Any) {
        if radianStatusLabel.isHidden == true {
            radianStatusLabel.isHidden = false
            radianDegreeLabel.setTitle( "Deg", for: .normal)
            calculationModule.isRadian = true
        } else {
            radianStatusLabel.isHidden = true
            radianDegreeLabel.setTitle( "Rad", for: .normal)
            calculationModule.isRadian = false
        }
    }
}

extension String  {
    func isNumber() -> Bool {
        return Double( self) != nil ? true : false
    }
}
