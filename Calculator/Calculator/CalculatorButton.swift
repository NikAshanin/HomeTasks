import UIKit

final class CalculatorButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
