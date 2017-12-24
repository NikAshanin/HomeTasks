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
            calculator.addInHistory(input: userInput)
        }
        guard let text = sender.currentTitle else {
            return
        }

        switch text {
        case ".":
            if !userInput.contains(".") {
                handleInput(".")
            }
//            if hasIndex(stringToSearch: userInput, characterToFind: ".") == false {
//                handleInput(".")
//            }
        case "C":
            cleanDisplay()
        case "e":
            calculator.currentResult = M_E
            updateDisplay()
            userInput = ""
        case "п":
            calculator.currentResult = Double(Float.pi)
            updateDisplay()
            userInput = ""
        case "2^nd":
            switchMode()
        case "Rad":
            calculator.radianMode = !calculator.radianMode
        default:
            calculator.performOperationByName(name: text)
            updateDisplay()
            userInput = ""
        }
    }
}

fileprivate extension CalculatorViewController {

    func switchMode() {
        for button in collectionOfButtons {
            guard let labelText = button.currentTitle else {
                return
            }
            button.setTitle(OperationTitles.switchStateForButton(withTitle: labelText), for: .normal)
        }
    }

//    func hasIndex(stringToSearch str: String, characterToFind chr: Character) -> Bool {
//        for c in str where c == chr {
//            return true
//        }
//        return false
//    }

    func handleInput(_ str: String) {
        if str == "-" {
            if userInput.hasPrefix(str) {
                userInput = String(userInput[userInput.index(after: userInput.startIndex)...])
            } else {
                userInput = str + userInput
            }
        } else {
            userInput += str
        }
        guard let currentResult = Double(userInput) else {
            return
        }
        calculator.currentResult = currentResult
        updateDisplay()
    }

    func updateDisplay() {
        if calculator.currentResult < Double(Int.max) && calculator.currentResult > Double(Int.min) {
            let iAcc = Int(calculator.currentResult)

            if calculator.currentResult - Double(iAcc) == 0 {
                numLabel.text = "\(iAcc)"
            } else {
                numLabel.text = "\(calculator.currentResult)"
            }
        } else {
            numLabel.text = "Error"
            userInput = ""
        }
    }

    func cleanDisplay() {
        userInput = ""
        calculator.currentResult = 0
        updateDisplay()
        calculator.clearHistory()
    }
}
