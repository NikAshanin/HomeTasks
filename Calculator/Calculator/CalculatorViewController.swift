import UIKit

final class CalculatorViewController: UIViewController {
    private var isTyping = false
    private var dotAlreadySet = false
    private var secondTurnOn = false
    private var brain = CalculatorBrain()
    private var displayValue: Double {
        get {
            return Double(display.text ?? "0") ?? 0
        }
        set {
            if  floor(newValue) == newValue && newValue < Double(Int.max) && newValue > Double(Int.min) {
                display.text = String(Int(newValue))
            } else {
                display.text = String(newValue)
            }
        }
    }
    @IBOutlet private var sinButton: RoundButton!
    @IBOutlet private var cosButton: RoundButton!
    @IBOutlet private var tanButton: RoundButton!
    @IBOutlet private var coshButton: RoundButton!
    @IBOutlet private var sinhButton: RoundButton!
    @IBOutlet private var tanhButton: RoundButton!
    @IBOutlet private var exButton: RoundButton!
    @IBOutlet private var lnButton: RoundButton!
    @IBOutlet private var logButton: RoundButton!
    @IBOutlet private var tenXButton: RoundButton!
    @IBOutlet private var changeColorToGray: [RoundButton]!
    @IBOutlet private var changeColorToWhite: [RoundButton]!
    @IBOutlet private var clearAC: RoundButton!
    @IBOutlet private var display: UILabel!
    @IBOutlet private var radDisplay: UILabel!
    @IBAction private func dotSet(_ sender: UIButton) {
        let dot = "."
        let textCurrentlyInDisplay = display.text ?? "0"
        if !dotAlreadySet &&  floor(Double(display.text ?? "0") ?? 0) == Double(display.text ?? "0")
            && display.text != nil {
            display.text = textCurrentlyInDisplay + dot
            dotAlreadySet = true
        }
    }
    @IBAction private func touchDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else {
            return
        }
        brain.buttonPressed = false
        if isTyping {
            guard let textCurrentlyInDisplay = display.text else {
                return
            }
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            brain.checkPressedButton()
            changeButtonColorToDefault()
            if display.text != "0" {
                clearAC.setTitle("C", for: UIControlState.normal)
            }
            isTyping = true
        }
    }
    @IBAction private func makeFuncChange(_ sender: Any) {
        if !secondTurnOn {
            sinButton.setTitle("sin⁻¹", for: UIControlState.normal)
            cosButton.setTitle("cosh⁻¹", for: UIControlState.normal)
            tanButton.setTitle("tan⁻¹", for: UIControlState.normal)
            sinhButton.setTitle("sinh⁻¹", for: UIControlState.normal)
            coshButton.setTitle("cosh⁻¹", for: UIControlState.normal)
            tanhButton.setTitle("tanh⁻¹", for: UIControlState.normal)
            exButton.setTitle("yˣ", for: UIControlState.normal)
            lnButton.setTitle("logₓ", for: UIControlState.normal)
            logButton.setTitle("log₂", for: UIControlState.normal)
            tenXButton.setTitle("2ˣ", for: UIControlState.normal)
            secondTurnOn = true
        } else {
            sinButton.setTitle("sin", for: UIControlState.normal)
            cosButton.setTitle("cos", for: UIControlState.normal)
            tanButton.setTitle("tan", for: UIControlState.normal)
            sinhButton.setTitle("sinh", for: UIControlState.normal)
            coshButton.setTitle("cosh", for: UIControlState.normal)
            tanhButton.setTitle("tanh", for: UIControlState.normal)
            exButton.setTitle("ex", for: UIControlState.normal)
            lnButton.setTitle("tanh", for: UIControlState.normal)
            logButton.setTitle("log₁₀", for: UIControlState.normal)
            tenXButton.setTitle("10x", for: UIControlState.normal)
            secondTurnOn = false
        }
    }
    @IBAction private func undoButton(_ sender: UIButton) {
        brain.doUndoFunction()
        if let result = brain.result {
            displayValue = result
            dotAlreadySet = false
        }
        isTyping = false
        if brain.buttonPressed {
            for i in 0...changeColorToGray.count-1 where changeColorToGray[i].titleLabel?.text ==
                brain.memoryArray[brain.memoryArrayLength].1 {
                    changeColorToGray[i].backgroundColor = #colorLiteral(red: 0.6391444206, green: 0.6392566562, blue: 0.6391373277, alpha: 1)
            }
            for i in 0...changeColorToWhite.count-1 where changeColorToWhite[i].titleLabel?.text ==
                brain.memoryArray[brain.memoryArrayLength].1 {
                    changeColorToWhite[i].setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal)
                    changeColorToWhite[i].backgroundColor =  UIColor.white
            }
        } else {
            changeButtonColorToDefault()
        }
    }
    @IBAction private func redoButton(_ sender: UIButton) {
        brain.doRedoFunction()
        if let result = brain.result {
            displayValue = result
            dotAlreadySet = false
        }
        isTyping = false
        if brain.buttonPressed {
            for i in 0...changeColorToGray.count-1 where changeColorToGray[i].titleLabel?.text ==
                brain.memoryArray[brain.memoryArrayLength].1 {
                    changeColorToGray[i].backgroundColor = #colorLiteral(red: 0.6391444206, green: 0.6392566562, blue: 0.6391373277, alpha: 1)
                }
            for i in 0...changeColorToWhite.count-1 where changeColorToWhite[i].titleLabel?.text ==
                brain.memoryArray[brain.memoryArrayLength].1 {
                    changeColorToWhite[i].setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal)
                    changeColorToWhite[i].backgroundColor =  UIColor.white
                }
            } else {
            changeButtonColorToDefault()
        }
    }
    @IBAction private func touchRadButton(_ sender: RoundButton) {
        if sender.currentTitle == "Rad" {
            brain.inDeg = false
            sender.setTitle("Deg", for: UIControlState())
            radDisplay.text = ""
        } else {
            brain.inDeg = true
            sender.setTitle("Rad", for: UIControlState())
            radDisplay.text = "Deg"
        }
    }
    @IBAction private func performOPeration(_ sender: UIButton) {
        for i in 0...changeColorToWhite.count-1 where changeColorToWhite[i].titleLabel?.text == sender.currentTitle {
                sender.setTitleColor(#colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1), for: UIControlState.normal); sender.backgroundColor =  UIColor.white
                brain.buttonPressed = true
        }
        for i in 0...changeColorToGray.count-1 where changeColorToGray[i].titleLabel?.text == sender.currentTitle {
                sender.backgroundColor =   #colorLiteral(red: 0.6391444206, green: 0.6392566562, blue: 0.6391373277, alpha: 1)
                brain.buttonPressed = true
            }
        if isTyping {
            brain.buttonPressed = false
            brain.setOperand(displayValue)
            isTyping = false
        }
        if  let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            if sender.currentTitle == "C" {
                self.display.text = "0"
                changeButtonColorToDefault()
            }
        }
        if let result = brain.result {
            displayValue = result
            dotAlreadySet = false
            if result == 0 {
                clearAC.setTitle("AC", for: UIControlState.normal)
            }
        }
    }
    private func changeButtonColorToDefault() {
        for i in 0...changeColorToGray.count-1 {
            changeColorToGray[i].backgroundColor = #colorLiteral(red: 0.1293928623, green: 0.1294226646, blue: 0.1293909252, alpha: 0.9120023545)
        }
        for i in 0...changeColorToWhite.count-1 {
            changeColorToWhite[i].setTitleColor(UIColor.white, for: UIControlState.normal)
            changeColorToWhite[i].backgroundColor = #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
        }
    }

}
