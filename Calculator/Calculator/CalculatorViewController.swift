import UIKit

final class CalculatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonsToArray(for: view)
        roundUpTheButtons()
        updateUI()
    }

    @IBOutlet private weak var display: UILabel! {
        didSet {
            displayText = display.text ?? ""
        }
    }
    @IBOutlet private weak var radiansStateLabel: UILabel!

    private var inTheMiddleOftyping = true
    private var buttonsArray: [UIButton] = []
    private lazy var model = Calculator()

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
        let multiplayer: CGFloat = traitCollection.horizontalSizeClass == .compact ? 0.7 : 0.9
        for button in buttonsArray {
            button.layer.cornerRadius = min(button.bounds.size.height, button.bounds.size.width) * multiplayer
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

    private func selectOperationButton(with title: String, in view: UIView) {
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
        radiansStateLabel.text = model.degreesMode ? "" : "Rad"
    }

    private func performClickAnimation(for title: String) {
        if let button = buttonsArray.first(where: { $0.currentTitle==title }) {
            UIView.transition(with: button,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { button.isHighlighted = true },
                              completion: { if $0 { button.isHighlighted = false } })
        }
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
        if model.pendingFunction != nil {
            model.resetPendingOperation()
        } else {
            let oldDegreeMode = model.degreesMode
            model = Calculator()
            model.degreesMode = oldDegreeMode
            inTheMiddleOftyping = true
            displayText = "0"
        }
    }

    @IBAction private func pressDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if inTheMiddleOftyping {
                displayText += digit
                if displayText[displayText.startIndex] == "0" &&
                    displayText[displayText.index(after: displayText.startIndex)] != "." {
                    displayText.remove(at: displayText.startIndex)
                }
            } else {
                displayText = digit == "." ? "0." : digit
            }
            inTheMiddleOftyping = true
        }
    }

    @IBAction private func performOperation (_ sender: UIButton) {
        guard let operationTitle = sender.currentTitle else {
            return
        }

        if inTheMiddleOftyping {
            model.setOperand(symbol)
            inTheMiddleOftyping = false
        }

        model.doOperation(operationTitle)

        updateUI()
    }

    private func updateUI() {
        if let res = model.result {
            symbol = res
        }

        resetSelectionForAllButtons()
        if let pendingFunction = model.pendingFunction {
            selectOperationButton(with: pendingFunction, in: view)
        }
    }
}
