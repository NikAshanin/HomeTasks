import UIKit

final class CalculatorViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var angleMeasureLabel: UILabel!

    @IBOutlet private weak var changeLabelsButton: UIButton!
    @IBOutlet private weak var angleMeasureButton: UIButton!
    @IBOutlet private var actionsButtons: [UIButton]!

    // MARK: - ViewController Properties
    private let maxNumberLength = 17
    private var hasPoint: Bool {
        return mainLabelString.contains(".")
    }
    private var isTyping = true
    private var mainLabelString: String {
        get {
            return mainLabel.text ?? "0"
        }
        set {
            mainLabel.text = newValue == "nan" ? "0" : newValue
        }
    }
    private var mainLabelDouble: Double {
        get {
            return Double(mainLabelString) ?? 0
        }
        set {
            if newValue == Double.infinity || newValue == -Double.infinity {
                AlertHelper.showAlert(title: "Result value is too huge!", message: "Stop it!")
            } else {
                if floor(newValue) == newValue, newValue < Double(Int.max), newValue > Double(Int.min) {
                    mainLabel.text = String(Int(newValue))
                } else {
                    mainLabel.text = String(newValue)
                }
            }
        }
    }
    private var changeLabelsButtonIsOn: Bool {
        get {
            return changeLabelsButton.backgroundColor == .customGreyColor
        }
        set {
            changeLabelsButton.backgroundColor = newValue ? .customGreyColor : .customBlackColor
        }
    }
    private var angleLabelString: String {
        get {
            return angleMeasureLabel.text ?? ""
        }
        set {
            angleMeasureLabel.text = newValue
        }
    }
    private var coloredButton: UIButton?

    // MARK: - ViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        mainLabel.text = "0"
    }

    // MARK: - Button actions methods
    @IBAction private func digitButtonPressed(_ sender: UIButton) {
        backNormalColorForButton()
        let symbol = sender.titleLabel?.text ?? ""
        if isTyping {
            if mainLabelString.count <= maxNumberLength {
                if symbol == "," {
                    if !hasPoint {
                        mainLabelString += "."
                    }
                } else {
                    if mainLabelString == "0" {
                        mainLabelString = symbol
                    } else {
                        mainLabelString += symbol
                    }
                }
            } else {
                AlertHelper.showAlert(title: "Too many symbols on the label!", message: "")
            }
        } else {
            if symbol != "," {
                mainLabelString = symbol
                isTyping = true
            }
        }
    }

    @IBAction private func changeLabelsButtonPressed(_ sender: UIButton) {
        let newButtonDictionaryKey = changeLabelsButtonIsOn ? "Off" : "On"
        let previousButtonDictionaryKey = changeLabelsButtonIsOn ? "On" : "Off"
        for button in actionsButtons {
            for buttonDictionary in CalculatorService.changingButtonsNamesArray where
                button.titleLabel?.text == buttonDictionary[previousButtonDictionaryKey] {
                    button.setTitle(buttonDictionary[newButtonDictionaryKey], for: .normal)
            }
        }
        changeLabelsButtonIsOn = !changeLabelsButtonIsOn
    }

    @IBAction private func angleButtonPressed(_ sender: UIButton) {
        angleLabelString = angleLabelString == "" ? "Rad" : ""
        let buttonTitle = angleLabelString == "" ? "Deg" : "Rad"
        angleMeasureButton.setTitle(buttonTitle, for: .normal)
    }

    @IBAction private func operationButtonPressed(_ sender: UIButton) {
        backNormalColorForButton()
        let operationString = sender.titleLabel?.text ?? ""
        switch operationString {
        case "=":
            mainLabelDouble = CalculatorService.resultOperation(second: mainLabelDouble) ?? mainLabelDouble
            isTyping = false
        case "AC":
            mainLabelString = "0"
            isTyping = true
        case "Undo", "Redo":
            let value = operationString == "Undo" ? StackHelper.undo() : StackHelper.redo()
            if BinaryOperation.allRawValues.contains(value) || UnaryOperation.allRawValues.contains(value) {
                for button in actionsButtons where button.titleLabel?.text == value {
                    changeColorFor(button: button)
                }
            } else {
                mainLabelDouble = Double(value) ?? 0
            }
            isTyping = false
        default:
            executeOperation(operationString: operationString)
        }
    }

    private func executeOperation(operationString: String) {
        switch operationString {
        case _ where BinaryOperation.allRawValues.contains(operationString):
            guard let operation = BinaryOperation(rawValue: operationString) else {
                break
            }
            mainLabelDouble = CalculatorService.binaryOperation(firstOperand: mainLabelDouble, operation: operation)
            isTyping = false
        case _ where UnaryOperation.allRawValues.contains(operationString):
            guard let operation = UnaryOperation(rawValue: operationString) else {
                break
            }
            mainLabelDouble = CalculatorService.unaryOperation(value: mainLabelDouble,
                                                               operation: operation,
                                                               withRadians: angleLabelString == "Rad") ?? 0
            isTyping = operation.rawValue == "±"
        case _ where NullaryOperation.allRawValues.contains(operationString):
            guard let operation = NullaryOperation(rawValue: operationString) else {
                break
            }
            mainLabelDouble = CalculatorService.nullaryOperation(operation: operation) ?? 0
            isTyping = false
        case _ where MemoryOperation.allRawValues.contains(operationString):
            guard let operation = MemoryOperation(rawValue: operationString) else {
                break
            }
            let result = CalculatorService.memoryOperation(value: mainLabelDouble, operation: operation)
            mainLabelDouble = result ?? mainLabelDouble
            isTyping = !(operation.rawValue == "mr" && result != nil)
        default:
            break
        }
    }

    // MARK: - Buttons' color change methods
    private func changeColorFor(button: UIButton) {
        coloredButton = coloredButton == nil ? button : nil
        let tmpColor = button.currentTitleColor
        button.setTitleColor(button.backgroundColor, for: .normal)
        button.backgroundColor = tmpColor
    }

    private func backNormalColorForButton() {
        guard let unwrappedColorButton = coloredButton else {
            return
        }
        changeColorFor(button: unwrappedColorButton)
    }
}
