import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    var userInTheMiddleOfTyping = false
   
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
    
    @IBAction func btnClear(_ sender: UIButton) {
        displayValue = 0
        userInTheMiddleOfTyping = false
        display.text! = "0"
        opStack.clear()
        clearBorder()
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String (newValue)
        }
    }
    
    var opStack = OperationStackController()
    private var calc = Calculator()
    var count=0

    @IBAction func performOPeration(_ sender: UIButton) {
        clearBorder()
        if userInTheMiddleOfTyping {
            calc.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        if count > 0 {
            calc.performOperation("=")
            let result = calc.result
            displayValue = result!
            calc.setOperand(displayValue)
        }
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "=" {
                count = 0
            }
            count+=1
            calc.performOperation(mathematicalSymbol)
            opStack.push(operand: displayValue, operation: mathematicalSymbol)
        }
        if let result = calc.result {
            displayValue = result
            calc.setOperand(displayValue)
            opStack.push(operand: displayValue, operation: nil)
        }
    }
    var flagToGoSecondOpiration: Bool = false
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
    
    @IBAction func getSecondPerformOperation(_ sender: UIButton) {
        clearBorder()
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
    
    var flagToGetRad: Bool = false
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
        clearBorder()
        guard let (operand, operation) = opStack.redo() else { return }
        displayValue = operand
        if let mathematicalSymbol = operation {
            self.searchTitle(mathematicalSymbol: mathematicalSymbol)
            calc.setOperand(displayValue)
            calc.performOperation(mathematicalSymbol)
        }
    }
    
    @IBAction func btnPreviousResult(_ sender: UIButton) {
        clearBorder()
        if let (operand, operation) = opStack.undo() {
            displayValue = operand
            if let mathematicalSymbol = operation {
                self.searchTitle(mathematicalSymbol: mathematicalSymbol)
                calc.setOperand(displayValue)
                calc.performOperation(mathematicalSymbol)
            }
        } else {
            displayValue = 0
        }
    }
    
    func clearBorder() {
        btnPlus.layer.borderWidth = 0
        btnMinus.layer.borderWidth = 0
        btnMultiply.layer.borderWidth = 0
        btnDivision.layer.borderWidth = 0
        btnEqual.layer.borderWidth = 0
        btnEXandYX.layer.borderWidth = 0
        btn10Xand2x.layer.borderWidth = 0
        btnLNandLOGy.layer.borderWidth = 0
        btnLOG10andLOG2.layer.borderWidth = 0
        btnSin.layer.borderWidth = 0
        btnCos.layer.borderWidth = 0
        btnTan.layer.borderWidth = 0
        btnSinh.layer.borderWidth = 0
        btnCosh.layer.borderWidth = 0
        btnTanh.layer.borderWidth = 0
        btnChangeSign.layer.borderWidth = 0
        btnPercent.layer.borderWidth = 0
        btnXFactorial.layer.borderWidth = 0
        btnSQRTy.layer.borderWidth = 0
        btnE.layer.borderWidth = 0
        btnPi.layer.borderWidth = 0
        btnRand.layer.borderWidth = 0
        btnLOG2.layer.borderWidth = 0
        btnSQRT3.layer.borderWidth = 0
        btnSQRT.layer.borderWidth = 0
        btn1X.layer.borderWidth = 0
        btnXY.layer.borderWidth = 0
        btnX3.layer.borderWidth = 0
        btnX2.layer.borderWidth = 0
    }
    
    func searchTitle(mathematicalSymbol: String) {
        switch mathematicalSymbol {
        case "+":
            btnPlus.layer.borderWidth = 1
            btnPlus.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "-":
            btnMinus.layer.borderWidth = 1
            btnMinus.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "×":
            btnMultiply.layer.borderWidth = 1
            btnMultiply.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "÷":
            btnDivision.layer.borderWidth = 1
            btnDivision.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "logy", "ln":
            btnLNandLOGy.layer.borderWidth = 1
            btnLNandLOGy.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "x!":
            btnXFactorial.layer.borderWidth = 1
            btnXFactorial.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "y√":
            btnSQRTy.layer.borderWidth = 1
            btnSQRTy.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "e^x","y^x":
            btnEXandYX.layer.borderWidth = 1
            btnEXandYX.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "x^y":
            btnXY.layer.borderWidth = 1
            btnXY.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        case "":
            break
        default:
            assertionFailure("Error in func searchTitle in ViewController")
    }
    }
}
