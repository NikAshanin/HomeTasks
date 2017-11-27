import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var btnEXandYX: UIButton!
    @IBOutlet weak var btn10Xand2x: UIButton!
    @IBOutlet weak var btnLNandLOGy: UIButton!
    @IBOutlet weak var btnLOG10andLOG2: UIButton!
    @IBOutlet weak var btnSin: UIButton!
    @IBOutlet weak var btnCos: UIButton!
    @IBOutlet weak var btnTan: UIButton!
    @IBOutlet weak var btnSinh: UIButton!
    @IBOutlet weak var btnTanh: UIButton!
    @IBOutlet weak var btnCosh: UIButton!
    @IBOutlet weak var labelRadOrDegInformation: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnDivision: UIButton!
    @IBOutlet weak var btnMultiply: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnEqual: UIButton!
    @IBOutlet weak var btnX2: UIButton!
    @IBOutlet weak var btnX3: UIButton!
    @IBOutlet weak var btnXY: UIButton!
    @IBOutlet weak var btn1X: UIButton!
    @IBOutlet weak var btnSQRT: UIButton!
    @IBOutlet weak var btnSQRT3: UIButton!
    @IBOutlet weak var btnLOG2: UIButton!
    @IBOutlet weak var btnRand: UIButton!
    @IBOutlet weak var btnPi: UIButton!
    @IBOutlet weak var btnE: UIButton!
    @IBOutlet weak var btnSQRTy: UIButton!
    @IBOutlet weak var btnXFactorial: UIButton!
    @IBOutlet weak var btnPercent: UIButton!
    @IBOutlet weak var btnChangeSign: UIButton!
    var userInTheMiddleOfTyping = false
    var flagToGoSecondOpiration: Bool = false
    var flagToGetRad: Bool = false
    var opStack = OperationStackController()
    private var calc = Calculator()
    var count=0
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle ?? ""
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text ?? ""
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userInTheMiddleOfTyping = true
        }
    }
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String (newValue)
        }
    }
    
    @IBAction func performOPeration(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            calc.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        guard sender.currentTitle != "C" else {
            userInTheMiddleOfTyping = false
            displayValue = 0
            display.text! = "0"
            opStack.clear()
            count = 0
            return
        }
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "=" {
                count = 0
            }
            if count > 0 {
                calc.performOperation("=")
                opStack.push(operand: displayValue, operation: mathematicalSymbol)
                let result = calc.result
                displayValue = result!
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
   
    @IBAction func getSecondPerformOperation(_ sender: UIButton) {
        if !flagToGoSecondOpiration {
            flagToGoSecondOpiration = true
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
            flagToGoSecondOpiration = false
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
        guard let (operand, operation) = opStack.redo() else { return }
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
