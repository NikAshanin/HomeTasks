import UIKit

final class CircleView: UIView {

    public let innerRadius: CGFloat = 100
    public let outerRadius: CGFloat = 140
    public let lineWidth: CGFloat = 3.0

    override func draw(_ rect: CGRect) {
        drawCircle(with: innerRadius)
        drawCircle(with: outerRadius)
    }

    private func drawCircle(with radius: CGFloat) {
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: CGFloat(0),
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = lineWidth

        layer.addSublayer(shapeLayer)
    }
}
