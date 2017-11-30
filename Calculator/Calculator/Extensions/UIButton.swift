import UIKit

@IBDesignable
public extension UIButton {

    @IBInspectable
    var select: String {
        get {
            return ""
        }
        set {
            if newValue == "white" {
                setBackgroundImage(UIImage(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), for: .selected)
            }

        }
    }

    @IBInspectable
    var highlight: String {
        get {
            return ""
        }
        set {
            if newValue == "white" {
                setBackgroundImage(UIImage(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), for: .highlighted)
            }
            if newValue == "gray" {
                setBackgroundImage(UIImage(color: #colorLiteral(red: 0.6509147286, green: 0.6510263681, blue: 0.6509000063, alpha: 1)), for: .highlighted)
            }
            if newValue == "black" {
                setBackgroundImage(UIImage(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), for: .highlighted)
            }
        }
    }
}
