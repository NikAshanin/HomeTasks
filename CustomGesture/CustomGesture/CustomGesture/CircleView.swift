import UIKit

@IBDesignable
class CircleView: UIView {
    // MARK: properties
    private var scale: CGFloat = 0.8
    var circleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    var circleRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }

    private func pathForCircle() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: circleCenter,
                                radius: circleRadius,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        print("Current radius is: \(circleRadius) with center in: \(circleCenter)")
        path.lineWidth = 5.0
        return path
    }
    override func draw(_ rect: CGRect) {
        UIColor.black.set()
        pathForCircle().stroke()
    }
}
 
