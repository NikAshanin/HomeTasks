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

    private let trigOperations: Set = ["sin-1", "sinh-1", "cos-1",
                                       "cosh-1", "tan-1", "tanh-1",
                                       "sinh", "sin", "cos",
                                       "cosh", "tan", "tanh"]
    private let formatter = NumberFormatter()
    private let processor = CalculatorProcessor.sharedInstance
    private let descriptionHandler = DescriptionHandler.sharedInstance
    private var userIsInTheMiddleOfTyping = false
    private var variables = [String: Double]()
    private var numberOfCharacterGraterThan16: Bool {
        return (displayLabel.text?.count)! >= 16
    }
    private var displayValue: Double {
        get {
            let displayText = displayLabel.text ?? "0"

            let displayTextWithoutCommas = displayText.replacingOccurrences(of: ",", with: ".")
            let displayTextWithoutCommasAndSpaces = displayTextWithoutCommas.replacingOccurrences(of: " ", with: "")

            return displayText == "M" ? (variables["M"] ?? 0) : Double(displayTextWithoutCommasAndSpaces) ?? 0
        }
        set {
            if let result = formatter.string(from: newValue as NSNumber) {
                let displayTextWithCommas = result.replacingOccurrences(of: ".", with: ",")
                displayLabel.text = displayTextWithCommas
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureFormatter()

        sequanceOfOperationsLabel.text = nil
        memoryLabel.text = nil
    }

    // MARK: - Actions

    @IBAction func nonOperationButtonTapped(_ sender: UIButton) {
        guard let character = sender.currentTitle else {
            assertionFailure("Failed to get the title")
            return
        }

        switch character {
        case "M": addVariable(named: character)
        case "→M": addValueToVariable()
        case ",": decimalPointTapped()
        case "C", "AC": cleanDisplay()
        case "Rad", "Deg": radToDeg(currentState: character)
        default: performDigitTapping(digit: character)
        }
    }

    @IBAction func performOperation(_ sender: UIButton) {
        guard let operation = sender.currentTitle else {
            assertionFailure("Failed to get the title")
            return
        }

        if operation == "Redo" {
            handleUndoRedo(operation: .redo)
        } else if operation == "Undo" {
            userIsInTheMiddleOfTyping ? deleteTapped() : handleUndoRedo(operation: .undo)
        } else {
            if userIsInTheMiddleOfTyping {
                processor.setOperand(formatToDergeeOrRad(number: displayValue, operation))

                userIsInTheMiddleOfTyping = false
            } else if processor.resultIsPending {
                processor.performOperation(operation)
            }

            processor.appendTo(.undo, symbol: operation)
            descriptionHandler.addToDescription(symbol: operation)
            processor.performOperation(operation)
            updateSequanceOfOperationLabel()
        }

        if let result = processor.result {
            displayValue = result
        }
    }

    @IBAction func randomNumber(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = true

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

    private func formatToDergeeOrRad(number: Double, _ operation: String) -> Double {
        var newNumber = number
        if trigOperations.contains(operation) && degreeToRadianButton.currentTitle == "Deg" {
            newNumber = number.degreesToRadians
            return newNumber
        }
        return number
    }

    private func handleUndoRedo(operation: UndoRedo) {
        switch operation {
        case .undo where !processor.isListEmpty(.undo) :
            processor.appendTo(.redo, symbol: processor.returnLastFrom(.undo))
            processor.removeLastFrom(.undo)

        case .redo where !processor.isListEmpty(.redo):
            processor.appendTo(.undo, symbol: processor.returnLastFrom(.redo))
            processor.removeLastFrom(.redo)

        default: return
        }
        descriptionHandler.cleanDescription()
        processor.calculateResult()

        updateSequanceOfOperationLabel()
    }

    private func updateSequanceOfOperationLabel() {
        guard let description = descriptionHandler.getDescription else {
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

    private func configureFormatter() {
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
    }

    private func decimalPointTapped() {
        userIsInTheMiddleOfTyping == false ? descriptionHandler.addToDescription(digit: "0") : ()
        if let text = displayLabel.text {
            text.contains(",") ? print("No dots allowed") : displayLabel.text?.append(",")
        }
        userIsInTheMiddleOfTyping = true
    }

    private func addVariable(named letter: String) {
        userIsInTheMiddleOfTyping = true
        processor.setValueTo(variable: letter)
        variables[letter] = 0
        displayLabel.text = letter
    }

    private func addValueToVariable() {
        variables["M"] = displayValue
        memoryLabel.text = displayLabel.text
        userIsInTheMiddleOfTyping = true
        print("M has value \(variables["M"] ?? 0)")
    }

    private func deleteTapped() {
        guard let text = displayLabel.text, userIsInTheMiddleOfTyping else {
            return
        }
        text.count > 1 ? displayLabel.text?.removeLast(1) : displayLabel.text?.removeAll()
    }

    private func performDigitTapping(digit: String) {
        if userIsInTheMiddleOfTyping {
            guard let displayText = displayLabel.text else {
                assertionFailure("Text is missing")
                return
            }

            if !numberOfCharacterGraterThan16 {
                displayLabel.text = displayText + digit
            }
        } else {
            displayLabel.text = digit
            userIsInTheMiddleOfTyping = true

            cleanButton.setTitle("C", for: .normal)
        }
    }

    private func cleanDisplay() {
        displayLabel.text = "0"

        userIsInTheMiddleOfTyping = false
        processor.resultIsPending = false

        descriptionHandler.cleanDescription()
        processor.removeAllFrom(.undo)
        processor.removeAllFrom(.redo)

        sequanceOfOperationsLabel.text = " "
        memoryLabel.text = " "

        cleanButton.setTitle("AC", for: .normal)
    }
}
