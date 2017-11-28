import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet weak private var display: UILabel!
    @IBOutlet weak private var btnEXandYX: UIButton!
    @IBOutlet weak private var btn10Xand2x: UIButton!
    @IBOutlet weak private var btnLNandLOGy: UIButton!
    @IBOutlet weak private var btnLOG10andLOG2: UIButton!
    @IBOutlet weak private var btnSin: UIButton!
    @IBOutlet weak private var btnCos: UIButton!
    @IBOutlet weak private var btnTan: UIButton!
    @IBOutlet weak private var btnSinh: UIButton!
    @IBOutlet weak private var btnTanh: UIButton!
    @IBOutlet weak private var btnCosh: UIButton!
    @IBOutlet weak private var labelRadOrDegInformation: UIButton!
    @IBOutlet weak private var btnMinus: UIButton!
    @IBOutlet weak private var btnDivision: UIButton!
    @IBOutlet weak private var btnMultiply: UIButton!
    @IBOutlet weak private var btnPlus: UIButton!
    @IBOutlet weak private var btnEqual: UIButton!
    @IBOutlet weak private var btnX2: UIButton!
    @IBOutlet weak private var btnX3: UIButton!
    @IBOutlet weak private var btnXY: UIButton!
    @IBOutlet weak private var btn1X: UIButton!
    @IBOutlet weak private var btnSQRT: UIButton!
    @IBOutlet weak private var btnSQRT3: UIButton!
    @IBOutlet weak private var btnLOG2: UIButton!
    @IBOutlet weak private var btnRand: UIButton!
    @IBOutlet weak private var btnPi: UIButton!
    @IBOutlet weak private var btnE: UIButton!
    @IBOutlet weak private var btnSQRTy: UIButton!
    @IBOutlet weak private var btnXFactorial: UIButton!
    @IBOutlet weak private var btnPercent: UIButton!
    @IBOutlet weak private var btnChangeSign: UIButton!
    var isTyping = false
    var flagToGoSecondOperation = false
    var flagToGetRad = false
    var opStack = Stack()
    private var calc = Calculator()
    var count=0

    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle ?? ""
        if isTyping {
            let textCurrentlyInDisplay = display.text ?? ""
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            isTyping = true
        }
    }

    var displayValue: Double {
        get {
            guard let value = display.text, let result = Double(value) else {
                return 0
            }
            return result
        }
        set {
            display.text = String (newValue)
        }
    }

    @IBAction private func performOPeration(_ sender: UIButton) {
        if isTyping {
            calc.setOperand(displayValue)
            isTyping = false
        }
        guard sender.currentTitle != "C" else {
            isTyping = false
            displayValue = 0
            opStack.clear()
            count = 0
            return
        }
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "=" {
                count = 0
            }
            if count >= 1 {
                calc.performOperation("=")
                opStack.push(operand: displayValue, operation: mathematicalSymbol)
                guard let result = calc.result else {
                    return
                }
                displayValue = result
                calc.setOperand(displayValue)
            }
            count+=1
            calc.performOperation(mathematicalSymbol)
            opStack.push(operand: displayValue, operation: mathematicalSymbol)
        }
        if let result = calc.result {
            displayValue = result
            calc.setOperand(displayValue)
        }
    }
    @IBAction private func getSecondPerformOperation(_ sender: UIButton) {
        if !flagToGoSecondOperation {
            flagToGoSecondOperation = true
            sender.layer.borderColor = UIColor.darkGray.cgColor
            sender.layer.borderWidth = 1
            btnEXandYX.setTitle("y^x", for: UIControlState.normal)
            btn10Xand2x.setTitle("2^x", for: UIControlState.normal)
            btnLNandLOGy.setTitle("logy", for: UIControlState.normal)
            btnLOG10andLOG2.setTitle("10^x", for: UIControlState.normal)
            btnSin.setTitle("sin^-1", for: UIControlState.normal)
            btnCos.setTitle("cos^-1", for: UIControlState.normal)
            btnTan.setTitle("tan^-1", for: UIControlState.normal)
            btnSinh.setTitle("sinh^-1", for: UIControlState.normal)
            btnCosh.setTitle("cosh^-1", for: UIControlState.normal)
            btnTanh.setTitle("tanh^-1", for: UIControlState.normal)
        } else {
            flagToGoSecondOperation = false
            sender.layer.borderWidth = 0
            btnEXandYX.setTitle("e^x", for: UIControlState.normal)
            btn10Xand2x.setTitle("10^x", for: UIControlState.normal)
            btnLNandLOGy.setTitle("ln", for: UIControlState.normal)
            btnLOG10andLOG2.setTitle("log10", for: UIControlState.normal)
            btnSin.setTitle("sin", for: UIControlState.normal)
            btnCos.setTitle("cos", for: UIControlState.normal)
            btnTan.setTitle("tan", for: UIControlState.normal)
            btnSinh.setTitle("sinh", for: UIControlState.normal)
            btnCosh.setTitle("cosh", for: UIControlState.normal)
            btnTanh.setTitle("tanh", for: UIControlState.normal)
        }
    }
    @IBAction func btnRadtoDeg(_ sender: UIButton) {
        if flagToGetRad {
            flagToGetRad = false
            sender.setTitle("Rad", for: .normal)
            sender.layer.borderWidth = 0
            labelRadOrDegInformation.setTitle("", for: UIControlState.normal)
        } else {
            flagToGetRad = true
            sender.layer.borderColor = UIColor.darkGray.cgColor
            sender.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
            sender.layer.borderWidth = 1
            sender.setTitle("Deg", for: .normal)
            labelRadOrDegInformation.setTitle("Rad", for: UIControlState.normal)
        }
    }
    @IBAction func btnNextResult(_ sender: UIButton) {
        guard let (operand, operation) = opStack.redo() else {
            return
        }
        displayValue = operand
        if let mathematicalSymbol = operation {
            calc.setOperand(displayValue)
            calc.performOperation(mathematicalSymbol)
        }
    }
    @IBAction func btnPreviousResult(_ sender: UIButton) {
        if let (operand, operation) = opStack.undo() {
            displayValue = operand
            if let mathematicalSymbol = operation {
                calc.setOperand(displayValue)
                calc.performOperation(mathematicalSymbol)
            }
        } else {
            displayValue = 0
        }
    }
}
