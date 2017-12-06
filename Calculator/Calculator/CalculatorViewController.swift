import UIKit

final class CalculatorViewController: UIViewController {

    private var isTyping = true
    private var buttonsArray: [UIButton] = []
    private var model = Calculator()

    @IBOutlet private weak var display: UILabel! {
        didSet {
            displayText = display.text ?? ""
        }
    }
    @IBOutlet private weak var radiansStateLabel: UILabel!

    private var displayText = "0" {
        didSet {
            display.text = displayText
        }
    }

    private var symbol: Double {
        get {
            return Double(displayText) ?? 0.0
        }
        set {
            let doubleValue = newValue.stringValue
            display.text = doubleValue
        }
    }

    private let titlesForButtonsWithTwoStates: [(firstState: String, secondState: String)] = [
        ("log₁₀", "log₂"),
        ("ln", "logᵧ"),
        ("10ˣ", "2ˣ"),
        ("eˣ", "yˣ"),
        ("cos", "cos⁻¹"),
        ("sin", "sin⁻¹"),
        ("tan", "tan⁻¹"),
        ("cosh", "cosh⁻¹"),
        ("sinh", "sinh⁻¹"),
        ("tanh", "tanh⁻¹")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonsToArray(for: view)
        roundUpTheButtons()
        updateUI()
    }

    private func addButtonsToArray (for view: UIView) {
        for subview in view.subviews {
            if let stack = subview as? UIStackView {
                addButtonsToArray(for: stack)
            } else if let button = subview as? UIButton {
                buttonsArray.append(button)
            }
        }
    }

    private func resetSelectionForAllButtons() {
        let filteredArray = buttonsArray.filter({
            if $0.currentTitle != "2ⁿᵈ", $0.currentTitle != radiansStateLabel.text {
                return true
            }
            return false
        })

        for button in filteredArray {
            button.isSelected = false
        }
    }

    private func roundUpTheButtons() {
        let multiplier: CGFloat = traitCollection.horizontalSizeClass == .compact ? 0.4 : 0.5
        for button in buttonsArray {
            button.layer.cornerRadius = min(button.bounds.size.height, button.bounds.size.width) * multiplier
            button.layer.masksToBounds = true
        }
    }

    private func changeTitlesForButtonsWithTwoStates(for view: UIView) {
        for button in buttonsArray {
            for (firstStateTitle, secondStateTitle) in titlesForButtonsWithTwoStates {
                if button.currentTitle==firstStateTitle {
                    button.setTitle(secondStateTitle, for: .normal)
                } else if button.currentTitle==secondStateTitle {
                    button.setTitle(firstStateTitle, for: .normal)
                }
            }
        }
    }

    private func selectOperationButton(with title: String) {
        for button in buttonsArray where button.currentTitle == title {
            button.isSelected = true
        }
    }

    @IBAction  private func changeTitlesTo2ndState(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeTitlesForButtonsWithTwoStates(for: view)
    }

    @IBAction private func switchRadianMode(_ sender: UIButton) {
        model.degreesMode = !model.degreesMode
        sender.setTitle(model.degreesMode ? "Rad" : "Deg", for: .normal)
        radiansStateLabel.isHidden = model.degreesMode ? true : false
    }

    @IBAction private func undo(_ sender: UIButton) {
        model.undo()
        updateUI()
    }

    @IBAction private func redo(_ sender: UIButton) {
        model.redo()
        updateUI()
    }

    @IBAction private func clear (_ sender: UIButton) {
        resetSelectionForAllButtons()
        let oldDegreeMode = model.degreesMode
        model = Calculator()
        model.degreesMode = oldDegreeMode
        isTyping = true
        displayText = "0"
    }

    @IBAction private func pressDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if isTyping {
                displayText += digit
                if displayText[displayText.startIndex] == "0" &&
                    displayText[displayText.index(after: displayText.startIndex)] != "." {
                    displayText.remove(at: displayText.startIndex)
                }
            } else {
                displayText = digit == "." ? "0." : digit
            }
            isTyping = true
        }
    }

    @IBAction private func performOperation (_ sender: UIButton) {
        guard let operationTitle = sender.currentTitle else {
            return
        }

        if isTyping {
            model.setOperand(symbol)
            isTyping = false
        }

        model.doOperation(operationTitle)

        updateUI()
    }

    private func updateUI() {
        symbol = model.result

        resetSelectionForAllButtons()
        if let pendingFunction = model.pendingFunction {
            selectOperationButton(with: pendingFunction)
        }
    }
}
