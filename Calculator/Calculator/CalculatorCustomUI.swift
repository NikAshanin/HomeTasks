import UIKit

final class CalculatorButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 20
    }
}

final class CalculatorLabel: UILabel {
    let edgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += edgeInsets.top + edgeInsets.bottom
        intrinsicSuperViewContentSize.width += edgeInsets.left + edgeInsets.right
        return intrinsicSuperViewContentSize
    }
}
