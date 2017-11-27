import UIKit

final class CalculatorViewController: UIViewController {

    @IBOutlet private weak var resultView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var decimalButton: UIButton! {
        didSet {
            decimalButton.setTitle(BaseNumberFormatter.decimalSeparator, for: .normal)
        }
    }
    @IBOutlet private weak var radianLabel: UILabel! {
        didSet {
            radianLabel?.isHidden = true
        }
    }
    @IBOutlet private weak var radianButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!

    private var result: Double? {
        get {
            guard let text = resultLabel.text,
                let doubleFromString = BaseNumberFormatter.double(from: text) else {
                    return nil
            }
            return doubleFromString
        }
        set {
            guard let value = newValue else {
                return
            }
            resultLabel.text = BaseNumberFormatter.string(from: value)
        }
    }
    private let decimalSeparator = BaseNumberFormatter.decimalSeparator
    private let calculation = Calculation()
    private var isTyping = false
    private var secondButtons = false
    private var redoArray: [String] = []
    private let secondButtonsDictionary = [
        "eˣ": "yˣ",
        "10ˣ": "2ˣ",
        "ln": "logᵧ",
        "log₁₀": "log₂",
        "sin": "sin⁻¹",
        "cos": "cos⁻¹",
        "tan": "tan⁻¹",
        "sinh": "sinh⁻¹",
        "cosh": "cosh⁻¹",
        "tanh": "tanh⁻¹",
        "yˣ": "eˣ",
        "2ˣ": "10ˣ",
        "logᵧ": "ln",
        "log₂": "log₁₀",
        "sin⁻¹": "sin",
        "cos⁻¹": "cos",
        "tan⁻¹": "tan",
        "sinh⁻¹": "sinh",
        "cosh⁻¹": "cosh",
        "tanh⁻¹": "tanh"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(undo))
        rightSwipe.direction = .right
        resultView.addGestureRecognizer(rightSwipe)

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(redo))
        leftSwipe.direction = .left
        resultView.addGestureRecognizer(leftSwipe)
    }

    @IBAction private func digitPressed(_ sender: UIButton) {
        guard let digit = sender.currentTitle,
            let currentResult = resultLabel.text else {
                return
        }
        if isTyping {
            if (!currentResult.contains(decimalSeparator) || digit != decimalSeparator) &&
                currentResult.count < 9 {
                resultLabel.text = currentResult + digit
            }
        } else {
            if digit != decimalSeparator && digit != "0" {
                resultLabel.text = digit
                isTyping = true
            } else if digit == decimalSeparator {
                resultLabel.text = "0" + digit
                isTyping = true
            } else {
                resultLabel.text = "0"
            }
        }
    }
    @IBAction private func secondButtonsPressed(_ sender: UIButton) {
        if  secondButtons {
            secondButton.backgroundColor = #colorLiteral(red: 0.1999770403, green: 0.2000165284, blue: 0.1999686658, alpha: 1)
            secondButton.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
            changeButtons()
            secondButtons = false
        } else {
            secondButton.backgroundColor = #colorLiteral(red: 0.7528685927, green: 0.7529936433, blue: 0.7528419495, alpha: 1)
            secondButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            changeButtons()
            secondButtons = true
        }
    }

    @IBAction private func performOperation(_ sender: UIButton) {
        guard let mathSign = sender.currentTitle,
            let operand = result else {
                return
        }
        if isTyping {
            calculation.setOperand(operand)
            isTyping = false
        }
        calculation.performOperation(mathSign)
        result = calculation.result
    }

    @IBAction private func radianButtonPressed(_ sender: UIButton) {
        if radianButton.currentTitle == "Rad" {
            radianButton.setTitle("Deg", for: .normal)
            radianLabel.isHidden = false
            calculation.isRadian = true
        } else {
            radianButton.setTitle("Rad", for: .normal)
            radianLabel.isHidden = true
            calculation.isRadian = false
        }
    }

    @IBAction private func clear(_ sender: UIButton) {
        calculation.clearAll()
        isTyping = false
        result = 0
        redoArray = []
    }
    @objc private func undo() {
        if isTyping {
            guard var text = resultLabel.text,
                let last = text.last else {
                    return
            }
            redoArray.append(String(describing: last))
            text.remove(at: text.index(before: text.endIndex))
            resultLabel.text = text
            if text.isEmpty {
                isTyping = false
                resultLabel.text = "0"
            }
        } else {
            redoArray.removeAll(keepingCapacity: false)
            calculation.undoCalculationParameter()
            result = calculation.result
        }
    }

    @objc private func redo() {
        guard let text = resultLabel.text else {
            return
        }
        if !redoArray.isEmpty && isTyping {
            resultLabel.text = text + redoArray.removeLast()
            print(redoArray)
        }
        calculation.redoCalculationParameter()
    }

    private func changeButtons() {
        view.runSubviewsRecursive {
            guard let button = $0 as? CalculatorButton,
                let buttonTitle = button.currentTitle else {
                    return
            }
            if let buttonTitle = secondButtonsDictionary[buttonTitle] {
                button.setTitle(buttonTitle, for: .normal)
            }
        }
    }
}

private extension UIView {
    func runSubviewsRecursive(for view: (UIView) -> Void) {
        subviews.forEach {
            view($0)
            $0.runSubviewsRecursive(for: view)
        }
    }
}
