import UIKit

class ViewController: UIViewController {
    /* Buttons without second functionality */
    @IBOutlet private weak var factorialButton: UIButton!
    @IBOutlet private weak var OneDividedByXButton: UIButton!
    @IBOutlet private weak var sqrXButton: UIButton!
    @IBOutlet private weak var trpXButton: UIButton!
    @IBOutlet private weak var XByYButton: UIButton!
    @IBOutlet private weak var RootYButton: UIButton!
    @IBOutlet private weak var triRootXButton: UIButton!
    @IBOutlet private weak var yRootXButton: UIButton!
    @IBOutlet private weak var EEButton: UIButton!
    @IBOutlet private weak var eNumButton: UIButton!
    @IBOutlet private weak var piNumButton: UIButton!
    @IBOutlet private weak var randNumButton: UIButton!
    @IBOutlet private weak var changeSignButton: UIButton!
    @IBOutlet private weak var divideButton: UIButton!
    @IBOutlet private weak var multiplyButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var remainderButton: UIButton!

    /* Buttons with second functionality */
    @IBOutlet private weak var x10Button: UIButton!
    @IBOutlet private weak var eButton: UIButton!
    @IBOutlet private weak var log10Button: UIButton!
    @IBOutlet private weak var lnButton: UIButton!
    @IBOutlet private weak var tanhButton: UIButton!
    @IBOutlet private weak var coshButton: UIButton!
    @IBOutlet private weak var sinhButton: UIButton!
    @IBOutlet private weak var tanButton: UIButton!
    @IBOutlet private weak var cosButton: UIButton!
    @IBOutlet private weak var sinButton: UIButton!

    /* Labels */
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var DegRad: UILabel!

    /* undo/redo */
    @IBOutlet private weak var undoButton: UIButton!
    @IBOutlet private weak var redoButton: UIButton!

    /* Dictionary : operation associated with Button */
    var operationDictionary: [String: UIButton] = [:]

    /* Flags */
    var wasOperator: Bool = false
    var isSecond: Bool = false
    var hightlightedButton: String = ""

    /* Stacks */
    var operationStack: Stack<String> = Stack<String>()
    var prevOperations: Stack<String> = Stack<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDictionary()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let bufStr = sender.titleLabel?.text ?? ""
        let strResultLabel = resultLabel.text ?? ""

        if operationDictionary[bufStr] != nil {
            pushToStack(resultLabel.text ?? "")
            resultLabel.text? = ""
            pushToStack(bufStr)
            calculate()
            pushToStack(strResultLabel)
            wasOperator = true
            return
        }

        switch bufStr {
        case "+/-" :
            if strResultLabel == "" {
                resultLabel.text = "-"
            } else if strResultLabel[strResultLabel.startIndex] == "-" {
                resultLabel.text?.remove(at: strResultLabel.startIndex)
            } else {
                resultLabel.text?.insert("-", at: strResultLabel.startIndex)
            }
        case "." :
            if !strResultLabel.contains(".") {
                resultLabel.text? += bufStr
            }
        case "Deg" :
            DegRad.text? = "Rad"
            sender.setTitle("Rad", for: .normal)
        case "Rad" :
            DegRad.text? = ""
            sender.setTitle("Deg", for: .normal)
        case "2^nd" :
            isSecond = !isSecond
            additionalButtonsChange()
        case "undo" :
            resultLabel.text? = undoOperation() ?? ""
        case "redo" :
            resultLabel.text? = redoOperation() ?? ""
        default:
            if wasOperator {
                resultLabel.text = ""
                wasOperator = false
            }
            resultLabel.text? += sender.titleLabel?.text ?? ""
        }
    }

    @IBAction func pressedEqual(_ sender: Any) {
        let strResultLabel = resultLabel.text ?? ""
        pushToStack(strResultLabel)
        calculate()
    }

    @IBAction func pressedClear(_ sender: Any) {
        resultLabel.text = ""
        operationStack.clear()
        wasOperator = false
    }

    func initDictionary() {
        operationDictionary["+"] =  plusButton
        operationDictionary["-"] = minusButton
        operationDictionary["/"] = divideButton
        operationDictionary["*"] = multiplyButton
        operationDictionary["%"] = remainderButton
        operationDictionary["x^y"] = XByYButton
        operationDictionary["x^2"] = sqrXButton
        operationDictionary["x^3"] = trpXButton
        operationDictionary["10^x"] = x10Button
        operationDictionary["e^x"] = eButton
        operationDictionary["log10"] = log10Button
        operationDictionary["1/x"] = OneDividedByXButton
        operationDictionary["sin"] = sinButton
        operationDictionary["cos"] = cosButton
        operationDictionary["tan"] = tanButton
        operationDictionary["2Root(x)"] = RootYButton
        operationDictionary["3Root(x)"] = triRootXButton
        operationDictionary["yRoot(x)"] = yRootXButton
        operationDictionary["ln"] = lnButton
        operationDictionary["pi"] = piNumButton
        operationDictionary["e"] = eNumButton
        operationDictionary["EE"] = EEButton
        operationDictionary["x!"] = factorialButton
        operationDictionary["RAND"] = randNumButton
        operationDictionary["sinh"] = sinhButton
        operationDictionary["cosh"] = coshButton
        operationDictionary["tanh"] = tanhButton
        operationDictionary["tanh^-1"] = tanhButton
        operationDictionary["cosh^-1"] = coshButton
        operationDictionary["sinh^-1"] = sinhButton
        operationDictionary["sin^-1"] = sinButton
        operationDictionary["cos^-1"] = cosButton
        operationDictionary["tan^-1"] = tanButton
        operationDictionary["log2"] = log10Button
        operationDictionary["2^x"] = x10Button
        operationDictionary["logy"] = lnButton
        operationDictionary["y^x"] = eButton
    }
}
// MARK: - Mathematic and logic
extension ViewController   {
    fileprivate func calculate() {
        var oper = operationStack.pop() ?? ""
        var number1: Double = 0.0
        var number2: Double? = nil
        var wasOperation: Bool = true
        if oper.isNumber() {
            number1 = Double(oper) ?? 0.0
            oper = operationStack.pop() ?? ""
        }
        else if !operationStack.isEmpty() {
            number1 = Double(operationStack.pop() ?? "") ?? 0.0
        }
        if !operationStack.isEmpty() {
            number2 = getNumber()
        }
        let strIsRad = DegRad.text ?? ""
        var isRad = false
        if strIsRad == "Rad" {
            isRad = true
        }

        switch oper {
        case "+" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(number2! + number1 ) : String(number1)
        case "-" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(number2! - number1 ) : String(number1)
        case "/" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(number2! / number1) : String(number1)
        case "*" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(number2! * number1) : String(number1)
        case "%" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(fmod(number2!, number1)) : String(number1)
        case "x^y" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(pow(number2!, number1)) : String(number1)
        case "x^2" :
            resultLabel.text = String(number1 * number1)
        case "x^3" :
            resultLabel.text = String(number1 * number1 * number1)
        case "10^x" :
            resultLabel.text = String(pow(10, number1))
        case "e^x" :
            resultLabel.text = String(pow(2.718281828459045, number1))
        case "log10" :
            resultLabel.text = String(log10(number1))
        case "1/x" :
            resultLabel.text = String(1/number1)
        case "sin" :
            resultLabel.text = String(sin(isRad ? number1.radianToDeg() : number1))
        case "cos" :
            resultLabel.text = String(cos(isRad ? number1.radianToDeg() : number1))
        case "tan" :
            resultLabel.text = String(tan(isRad ? number1.radianToDeg() : number1))
        case "2Root(x)" :
            resultLabel.text = String(sqrt(number1))
        case "3Root(x)" :
            resultLabel.text = String(pow(number1, 1/3))
        case "yRoot(x)" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(pow(number2!, 1/number1)) : String(number1)
        case "ln" :
            resultLabel.text = String(log(log(number1))/log(2.718281828459045))
        case "pi" :
            resultLabel.text = String(Double.pi)
        case "e" :
            resultLabel.text = String(2.718281828459045)
        case "EE" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(number1 * pow(10, number2!)) : String(number1)
        case "x!" :
            var factorial: Int = 1
            for i in 1..<(Int(number1) + 1) { factorial = factorial * i }
            resultLabel.text = String(factorial)
        case "RAND" :
            resultLabel.text = String(Double(arc4random()) / Double(UInt32.max))
        case "sinh" :
            resultLabel.text = String(sinh(isRad ? number1.radianToDeg() : number1))
        case "cosh" :
            resultLabel.text = String(cosh(isRad ? number1.radianToDeg() : number1))
        case "tanh" :
            resultLabel.text = String(tanh(isRad ? number1.radianToDeg() : number1))
        case "tanh^-1" :
            resultLabel.text = String(1 / tanh(isRad ? number1.radianToDeg() : number1))
        case "cosh^-1" :
            resultLabel.text = String(1 / cosh(isRad ? number1.radianToDeg() : number1))
        case "sinh^-1" :
            resultLabel.text = String(1 / sinh(isRad ? number1.radianToDeg() : number1))
        case "sin^-1" :
            resultLabel.text = String(1 / sin(isRad ? number1.radianToDeg() : number1))
        case "cos^-1" :
            resultLabel.text = String(1 / cos(isRad ? number1.radianToDeg() : number1))
        case "tan^-1" :
            resultLabel.text = String(1 / tan(isRad ? number1.radianToDeg() : number1))
        case "log2" :
            resultLabel.text = String(log2(number1))
        case "2^x" :
            resultLabel.text = String(pow(2, number1))
        case "logy" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(log(number2!)/log(number1)) : String(number1)
        case "y^x" :
            wasOperation = number2 != nil
            resultLabel.text = wasOperation ? String(pow(number2!, number1)) : String(number1)
        default:
            return
        }

        if !wasOperation {
            var _ = operationStack.unPop()
            _ = operationStack.unPop()
        } else {
            pushToStack(resultLabel.text ?? "")
        }
    }

    func pushToStack(_ str: String) {
        var operatorDuplication = operationStack.top() ?? ""
        if operatorDuplication != str {
            operationStack.push(str)
        }
        operatorDuplication = prevOperations.top() ?? ""
        if operatorDuplication  != str {
            prevOperations.push(str)
        }
    }

    func additionalButtonsChange() {
        if isSecond {
            log10Button.setTitle("log2", for: .normal)
            lnButton.setTitle("logy", for: .normal)
            tanhButton.setTitle("tanh^-1", for: .normal)
            coshButton.setTitle("cosh^-1", for: .normal)
            sinhButton.setTitle("sinh^-1", for: .normal)
            tanButton.setTitle("tan^-1", for: .normal)
            cosButton.setTitle("cos^-1", for: .normal)
            sinButton.setTitle("sin^-1", for: .normal)
            x10Button.setTitle("2^x", for: .normal)
            eButton.setTitle("y^x", for: .normal)
        } else {
            log10Button.setTitle("log10", for: .normal)
            lnButton.setTitle("ln", for: .normal)
            tanhButton.setTitle("tanh", for: .normal)
            coshButton.setTitle("cosh", for: .normal)
            sinhButton.setTitle("sinh", for: .normal)
            tanButton.setTitle("tan", for: .normal)
            cosButton.setTitle("cos", for: .normal)
            sinButton.setTitle("sin", for: .normal)
            x10Button.setTitle("10^x", for: .normal)
            eButton.setTitle("e^x", for: .normal)
        }
    }

    func undoOperation() -> String? {
        let prevOperation = prevOperations.pop()
        hightlightOperation(prevOperation ?? "")
        return prevOperation
    }
    func redoOperation() -> String? {
        let nextOperation = prevOperations.unPop()
        hightlightOperation(nextOperation ?? "")
        return nextOperation
    }
    func hightlightOperation(_ operation: String) {
        let button = operationDictionary[operation]
        if button != nil {
            button?.isSelected = !(button?.isSelected ?? true)
        }
        let previousHighlightedButton = operationDictionary[hightlightedButton]
        if previousHighlightedButton != nil {
            previousHighlightedButton?.isSelected = !(previousHighlightedButton?.isSelected ?? true)
        }
        hightlightedButton = button?.titleLabel?.text ?? ""
    }

    func getNumber() -> Double? {
        if operationStack.isEmpty() {
            return nil
        }
        let number: Double? = Double(operationStack.pop() ?? "")
        if number == nil {
            return getNumber()
        }
        return number
    }
}

// MARK: check is number or not
extension String {
    func isNumber() -> Bool {
        return Double(self) != nil ? true : false
    }
}

// MARK: convert radian to degrees
extension Double {
    func radianToDeg() -> Double {
        return self * 180 / .pi
    }
}
