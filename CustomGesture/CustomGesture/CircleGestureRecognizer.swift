import UIKit
import UIKit.UIGestureRecognizerSubclass

final class CircleGestureRecognizer: UIGestureRecognizer {

    // MARK: - Private properties

    private var midPoint: CGPoint
    private var innerRadius: CGFloat
    private var outerRadius: CGFloat
    private var currentPoint: CGPoint?
    private var previousPoint: CGPoint?

    // MARK: - Public properties

    var rotationAngle: CGFloat? {
        guard let currentPoint = currentPoint, let previousPoint = previousPoint else {
            return nil
        }

        var rotationAngle = angleBetween(pointA: currentPoint, andPointB: previousPoint)

        if rotationAngle > CGFloat.pi {
            rotationAngle -= CGFloat.pi * 2
        } else if rotationAngle < -CGFloat.pi {
            rotationAngle += CGFloat.pi * 2
        }
        return rotationAngle
    }

    var distanceBetweenMidAndCurrent: CGFloat? {
        guard let nowPoint = currentPoint else {
            return nil
        }
        return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
    }

    // MARK: - Initialization

    init(midPoint: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, target: AnyObject?, action: Selector) {
        self.midPoint = midPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        super.init(target: target, action: action)
    }

    // MARK: - Public methods

    func distanceBetween(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dx = pointA.x - pointB.x
        let dy = pointA.y - pointB.y
        return CGFloat(sqrtf(Float(dx*dx + dy*dy)))
    }

    func angle(for point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + CGFloat.pi/2

        if angle < 0 {
            angle += CGFloat.pi * 2
        }
        return angle
    }

    func angleBetween(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        return angle(for: pointA) - angle(for: pointB)
    }

    // MARK: - GestureRecognizer methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        guard let firstTouch = touches.first else {
            return
        }

        currentPoint = firstTouch.location(in: self.view)

        if let distance = self.distanceBetweenMidAndCurrent {
            if distance < innerRadius {
                return
            }
        }

        if let distance = self.distanceBetweenMidAndCurrent {
            if distance > outerRadius {
                return
            }
        }
        state = .began
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard state != .failed else {
            return
        }

        guard let firstTouch = touches.first else {
            return
        }

        currentPoint = firstTouch.location(in: self.view)
        previousPoint = firstTouch.previousLocation(in: self.view)

        state = .changed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended

        currentPoint = nil
        previousPoint = nil
    }
}
