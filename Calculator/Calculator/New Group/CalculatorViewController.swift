import UIKit

final class CalculatorViewController: UIViewController {

    @IBOutlet private var collectionOfButtons: [UIButton]!
    @IBOutlet private weak var numLabel: UILabel!
    private var userInput = "" // Вводимое пользователем число
    private let calculator = Calculator()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func numberButtonPressed(_ sender: UIButton) {
        guard let labelText = sender.currentTitle else {
            return
        }
        handleInput(labelText)
    }

    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if userInput != "" {
            calculator.setNumber(input: userInput)
        }
        guard let text = sender.currentTitle else {
            return
        }

        switch text {
        case ".":
            if !userInput.contains(".") {
                handleInput(".")
            }
        case "C":
            cleanDisplay()
        case "2^nd":
            switchMode()
        case "Rad":
            calculator.switchRadianMode()
        default:
            calculator.performOperationByName(name: text)
            updateDisplay(with: calculator.result)
            userInput = ""
        }
    }
}

fileprivate extension CalculatorViewController {

    private func switchMode() {
        for button in collectionOfButtons {
            guard let labelText = button.currentTitle else {
                return
            }
            button.setTitle(OperationTitles.switchStateForButton(withTitle: labelText), for: .normal)
        }
    }

    private func handleInput(_ str: String) {
        if str == "-" {
            if userInput.hasPrefix(str) {
                userInput = String(userInput[userInput.index(after: userInput.startIndex)...])
            } else {
                userInput = str + userInput
            }
        } else {
            userInput += str
        }
        updateDisplay(with: userInput)
    }

    private func updateDisplay(with numValue: Double) {
        if numValue < Double(Int.max) && numValue > Double(Int.min) {
            let iAcc = Int(numValue)

            if numValue - Double(iAcc) == 0 {
                updateDisplay(with: "\(iAcc)")
            } else {
                updateDisplay(with: "\(numValue)")
            }
        } else {
            updateDisplay(with: "Error")
            userInput = ""
        }
    }

    private func updateDisplay(with rawValue: String) {
        numLabel.text = rawValue
    }

    private func cleanDisplay() {
        userInput = ""
        calculator.clear()
        updateDisplay(with: userInput)
    }
}
