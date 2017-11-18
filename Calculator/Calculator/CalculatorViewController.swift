import UIKit

extension UIView {
    func runSubviewsRecursive(_ allSubviews: (UIView) -> Void) {
        subviews.forEach {
            allSubviews($0)
            $0.runSubviewsRecursive(allSubviews)
        }
    }
}
final class CalculatorViewController: UIViewController {

    @IBOutlet private weak var resultView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var decimalButton: UIButton! {
        didSet {
            decimalButton.setTitle(formatter.decimalSeparator, for: .normal)
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
                let doubleFromString = formatter.number(from: text)?.doubleValue else {
                    return nil
        }
            return doubleFromString
    }
        set {
            guard let value = newValue else {
                return
            }
            resultLabel.text = formatter.string(from: NSNumber(value: value))
        }
    }
    private let decimalSeparator = formatter.decimalSeparator ?? "."
    private var stillTyping = false
    private var secondButtons = false
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

    }

    @IBAction private func digitPressed(_ sender: UIButton) {
        guard let digit = sender.currentTitle,
        let currentResult = resultLabel.text else {
            return
        }
        if stillTyping {
            if (!currentResult.contains(decimalSeparator) || digit != decimalSeparator) &&
                currentResult.count < 9 {
                resultLabel.text = currentResult + digit
            }
        } else {
            if digit != decimalSeparator && digit != "0" {
                resultLabel.text = digit
                stillTyping = true
            } else if digit == decimalSeparator {
                resultLabel.text = "0" + digit
                stillTyping = true
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
        if stillTyping {

        }
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
