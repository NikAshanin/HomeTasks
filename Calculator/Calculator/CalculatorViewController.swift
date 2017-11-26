import UIKit

final class CalculatorViewController: UIViewController {
    @IBOutlet private var displayLabel: CalculatorLabel!
    @IBOutlet private var binaryOperationLabel: UILabel!
    private let maximumDigitsCount = 20
    private let model = Model()
    private var binaryOperation = ""
    private var newLine = true
    private var displayString = "0"

    @IBAction private func digitButtonPressed(_ sender: CalculatorButton) {
        pushDisplayStringToUndoStack()
        let digit = sender.currentTitle ?? ""
        if newLine {
            newLine = false
            setDisplayTextTo(digit == "." ? "0." : digit)
        } else {
            if !(digit == "." && displayString.contains(".")),
                displayString.count < maximumDigitsCount {
                setDisplayTextTo(displayString + digit)
            }
        }
    }

    @IBAction private func binaryOperatorButtonPressed(_ sender: CalculatorButton) {
        pushDisplayStringToUndoStack()
        setBinaryOperationTo(sender.currentTitle ?? "")
        model.firstOperand = Double(displayString) ?? Double.nan
        newLine = true
    }

    @IBAction private func unaryOperatorButtonPressed(_ sender: CalculatorButton) {
        pushDisplayStringToUndoStack()
        model.firstOperand = Double(displayString) ?? Double.nan
        setDisplayTextTo(model.performOperation(sender.currentTitle ?? "").toNoZeroTerminatingString())
        newLine = true
    }

    @IBAction private func calculateButtonPressed(_ sender: CalculatorButton) {
        pushDisplayStringToUndoStack()
        model.secondOperand = Double(displayString) ?? Double.nan
        setDisplayTextTo(model.performOperation(binaryOperation).toNoZeroTerminatingString())
        newLine = true
        setBinaryOperationTo("")
    }

    private func setDisplayTextTo(_ value: String) {
        displayString = value
        DispatchQueue.main.async {
            self.displayLabel.text = value
        }
    }

    private func setBinaryOperationTo(_ value: String) {
        binaryOperation = value
        DispatchQueue.main.async {
            self.binaryOperationLabel.text = value
        }
    }

    // MARK: undo, redo
    private struct UndoStep {
        public let digitString: String
        public let binaryOperation: String
        public let newLine: Bool

        init(_ digitString: String, _ binaryOperation: String, _ newLine: Bool) {
            self.digitString = digitString
            self.binaryOperation = binaryOperation
            self.newLine = newLine
        }
    }

    @IBOutlet private var undoButton: CalculatorButton!
    @IBOutlet private var redoButton: CalculatorButton!
    private var undoStack: Stack<UndoStep> = Stack<UndoStep>() {
        didSet {
            undoButton.isEnabled = undoStack.isEmpty ? false : true
        }
    }
    private var redoStack: Stack<UndoStep> = Stack<UndoStep>() {
        didSet {
            redoButton.isEnabled = redoStack.isEmpty ? false : true
        }
    }

    @IBAction private func undoButtonPressed(_ sender: CalculatorButton) {
        if let topUndoStackElement = undoStack.pop() {
            redoStack.push(UndoStep(displayString, binaryOperation, newLine))
            setDisplayTextTo(topUndoStackElement.digitString)
            setBinaryOperationTo(topUndoStackElement.binaryOperation)
            newLine = topUndoStackElement.newLine
        }
    }

    @IBAction private func redoButtonPressed(_ sender: CalculatorButton) {
        if let topRedoStackElement = redoStack.pop() {
            undoStack.push(UndoStep(displayString, binaryOperation, newLine))
            setDisplayTextTo(topRedoStackElement.digitString)
            setBinaryOperationTo(topRedoStackElement.binaryOperation)
            newLine = topRedoStackElement.newLine
        }
    }

    private func pushDisplayStringToUndoStack() {
        undoStack.push(UndoStep(displayString, binaryOperation, newLine))
        redoStack.clear()
    }

    // MARK: - Angle rate
    @IBOutlet private var angleRateButton: CalculatorButton!
    @IBOutlet private var angleMeasureUnitLabel: UILabel!
    private var isDegrees = false {
        didSet {
            if isDegrees {
                angleRateButton.setTitle("Rad", for: .normal)
                angleMeasureUnitLabel.text = "Deg"
                model.setAngleRateTo(.degrees)
            } else {
                angleRateButton.setTitle("Deg", for: .normal)
                angleMeasureUnitLabel.text = "Rad"
                model.setAngleRateTo(.radians)
            }
        }
    }

    @IBAction func angleRateButtonPressed(_ sender: CalculatorButton) {
        isDegrees = !isDegrees
    }

    // MARK: - Button settings
    @IBOutlet private var doubleStateButtons: [CalculatorButton]!
    private var isExtendedMode = false {
        didSet {
            for button in doubleStateButtons {
                let titles = buttonTitles[button.tag]
                if let title = isExtendedMode ? titles?.1 : titles?.0 {
                    button.setTitle(title, for: .normal)
                }
            }
        }
    }
    private let buttonTitles: [Int: (String, String)] = [
        1: ("xʸ", "yˣ"),
        2: ("10ˣ", "2ˣ"),
        3: ("ʸ√x", "logy"),
        4: ("log₁₀", "log₂"),
        5: ("sin", "sin-¹"),
        6: ("cos", "cos-¹"),
        7: ("tan", "tan-¹"),
        8: ("sinh", "sinh-¹"),
        9: ("cosh", "cosh-¹"),
        10: ("tanh", "tanh-¹")
    ]

    @IBAction private func changeButtonsState(_ sender: Any) {
        isExtendedMode = !isExtendedMode
    }
}

fileprivate extension Double {
    func toNoZeroTerminatingString() -> (String) {
        return floor(self) == self ? String(format: "%g", self) : "\(self)"
    }
}
