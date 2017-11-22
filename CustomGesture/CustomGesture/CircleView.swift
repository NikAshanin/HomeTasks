import UIKit

final class CircleView: UIView {

    var lineWidth: CGFloat {
        return 50
    }

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: (bounds.width - lineWidth) / 2,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        circlePath.lineWidth = lineWidth
        circlePath.stroke()
    }
}
