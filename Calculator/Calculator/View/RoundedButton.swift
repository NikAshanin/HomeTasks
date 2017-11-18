import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
}
