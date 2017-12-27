import UIKit

final class CalculatorViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak private var sequanceOfOperationsLabel: UILabel!
    @IBOutlet weak private var displayLabel: UILabel!
    @IBOutlet weak private var memoryLabel: UILabel!

    @IBOutlet weak private var exyxButton: RoundedButton!
    @IBOutlet weak private var from10x2xButton: RoundedButton!
    @IBOutlet weak private var fromLntoLogy: RoundedButton!
    @IBOutlet weak private var fromLog10toLog2: RoundedButton!
    @IBOutlet weak private var sinMinus1: RoundedButton!
    @IBOutlet weak private var sinhMinus1: RoundedButton!
    @IBOutlet weak private var cosMinus1: RoundedButton!
    @IBOutlet weak private var coshMinus1: RoundedButton!
    @IBOutlet weak private var tanMinus1: RoundedButton!
    @IBOutlet weak private var tanhMinus1: RoundedButton!
    @IBOutlet weak private var cleanButton: RoundedButton!
    @IBOutlet weak private var degreeToRadianButton: RoundedButton!
    @IBOutlet weak private var divideButton: RoundedButton!
    @IBOutlet weak private var multiplyButton: RoundedButton!
    @IBOutlet weak private var minusButton: RoundedButton!
    @IBOutlet weak private var plusButton: RoundedButton!

    // MARK: - Private properties

    private let formatter = NumberFormatterConfigurator()
    private let processor = CalculatorProcessor()
    private var userBeganTyping = false
    private var isLimitReached: Bool {
        return (displayLabel.text?.count)! >= 16
    }
    private var displayValue: Double {
        get {
            let displayText = displayLabel.text ?? "0"

            return Double(displayText) ?? 0
        }
        set {
            if let result = formatter.string(from: newValue as NSNumber) {
                displayLabel.text = result
            }
        }
    }

    // MARK: - Actions

    @IBAction private func nonOperationButtonTapped(_ sender: UIButton) {
        guard let character = sender.currentTitle else {
            assertionFailure("Failed to get the title")
            return
        }

        switch character {
        case ".": decimalPointTapped()
        case "C", "AC": cleanDisplay()
        case "Rad", "Deg": radToDeg(currentState: character)
        default: performDigitTapping(digit: character)
        }
    }

    @IBAction private func performOperation(_ sender: UIButton) {
        guard let operation = sender.currentTitle else {
            assertionFailure("Failed to get the title")
            return
        }

        if operation == UndoRedo.redo.rawValue {
            handleUndoRedo(operation: .redo)
        } else if operation == UndoRedo.undo.rawValue {
            userBeganTyping ? deleteTapped() : handleUndoRedo(operation: .undo)
        } else {
            if userBeganTyping {
                processor.setOperand(degreeToRadianButton.currentTitle == "Deg" ?
                    displayValue.formatToDergeeOrRad(operation: operation) : displayValue)

                userBeganTyping = false
            } else if processor.resultIsPending {
                processor.performOperation(operation)
            }

            processor.appendTo(.undo, symbol: operation)
            processor.performOperation(operation)
            updateSequanceOfOperationLabel()
        }

        if let result = processor.result {
            displayValue = result
        }
    }

    @IBAction func randomNumber(_ sender: UIButton) {
        userBeganTyping = true

        let result = Double(drand48())
        displayLabel.text = String(result)
    }

    @IBAction func showAdditionalOperations(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            sender.titleLabel?.textColor = UIColor.black
            sender.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.5019607843, alpha: 1)

            changeFunctionButtons()
        } else if sender.isSelected {
            sender.isSelected = false
            sender.titleLabel?.textColor = UIColor.white
            sender.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1333333333, alpha: 1)

            changeFunctionButtonsBack()
        }
    }

    // MARK: - Private

    private func handleUndoRedo(operation: UndoRedo) {
        switch operation {
        case .undo where !processor.isListEmpty(.undo) :
            processor.appendTo(.redo, symbol: processor.returnLastFrom(.undo))

        case .redo where !processor.isListEmpty(.redo):
            processor.appendTo(.undo, symbol: processor.returnLastFrom(.redo))

        default: return
        }

        processor.cleanDescription()
        processor.calculateResult()
        updateSequanceOfOperationLabel()
    }

    private func updateSequanceOfOperationLabel() {
        guard let description = processor.getDescription else {
            assertionFailure("There is no description")
            return
        }

        if processor.resultIsPending {
            sequanceOfOperationsLabel.text = description + "..."
        } else if processor.isListEmpty(.undo) {
            sequanceOfOperationsLabel.text = description
        } else {
            sequanceOfOperationsLabel.text = description + "="
        }
    }

    private func radToDeg(currentState: String) {
        if currentState == "Rad" {
            degreeToRadianButton.setTitle("Deg", for: .normal)
        } else {
            degreeToRadianButton.setTitle("Rad", for: .normal)
        }
    }

    private func changeFunctionButtons() {
        exyxButton.setTitle("y^x", for: .normal)
        from10x2xButton.setTitle("2^x", for: .normal)
        fromLntoLogy.setTitle("logy", for: .normal)
        fromLog10toLog2.setTitle("log2", for: .normal)
        sinMinus1.setTitle("sin-1", for: .normal)
        sinhMinus1.setTitle("sinh-1", for: .normal)
        cosMinus1.setTitle("cos-1", for: .normal)
        coshMinus1.setTitle("cosh-1", for: .normal)
        tanMinus1.setTitle("tan-1", for: .normal)
        tanhMinus1.setTitle("tanh-1", for: .normal)
    }

    private func changeFunctionButtonsBack() {
        exyxButton.setTitle("e^x", for: .normal)
        from10x2xButton.setTitle("10^x", for: .normal)
        fromLntoLogy.setTitle("ln", for: .normal)
        fromLog10toLog2.setTitle("log10", for: .normal)
        sinMinus1.setTitle("sin", for: .normal)
        sinhMinus1.setTitle("sinh", for: .normal)
        cosMinus1.setTitle("cos", for: .normal)
        coshMinus1.setTitle("cosh", for: .normal)
        tanMinus1.setTitle("tan", for: .normal)
        tanhMinus1.setTitle("tanh", for: .normal)
    }

    private func decimalPointTapped() {
        userBeganTyping == false ? processor.setOperand(0) : ()
        if let text = displayLabel.text {
            text.contains(".") ? print("No dots allowed") : displayLabel.text?.append(".")
        }
        userBeganTyping = true
    }

    private func deleteTapped() {
        guard let text = displayLabel.text, userBeganTyping else {
            return
        }
        text.count > 1 ? displayLabel.text?.removeLast(1) : displayLabel.text?.removeAll()
    }

    private func performDigitTapping(digit: String) {
        if userBeganTyping {
            guard let displayText = displayLabel.text else {
                assertionFailure("Text is missing")
                return
            }

            if !isLimitReached {
                displayLabel.text = displayText + digit
            }
        } else {
            displayLabel.text = digit
            userBeganTyping = true

            cleanButton.setTitle("C", for: .normal)
        }
    }

    private func cleanDisplay() {
        displayLabel.text = "0"
        userBeganTyping = false
        sequanceOfOperationsLabel.text = " "
        memoryLabel.text = " "

        cleanButton.setTitle("AC", for: .normal)

        processor.handleClean()
    }
}
