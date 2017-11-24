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

        var rotationAngle = distanceBetween(currentPoint, and: previousPoint)

        if rotationAngle > CGFloat.pi {
            rotationAngle -= CGFloat.pi * 2
        } else if rotationAngle < -CGFloat.pi {
            rotationAngle += CGFloat.pi * 2
        }
        return rotationAngle
    }

    var radius: CGFloat? {
        guard let nowPoint = currentPoint else {
            return nil
        }
        return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
    }

    var rotationValue: CGFloat = 0

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
        return CGFloat(sqrt(dx*dx + dy*dy))
    }

    func angle(for point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2((point.x - midPoint.x), (point.y - midPoint.y))) + CGFloat.pi/2
        if angle < 0 {
            angle += CGFloat.pi * 2
        }
        return angle
    }

    func distanceBetween(_ pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
        return angle(for: pointA) - angle(for: pointB)
    }

    // MARK: - GestureRecognizer methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard let firstTouch = touches.first else {
            return
        }

        currentPoint = firstTouch.location(in: view)

        if let distance = radius, distance < innerRadius {
            return
        }

        if let distance = radius, distance > outerRadius {
            return
        }

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard state != .failed, let firstTouch = touches.first else {
            return
        }

        currentPoint = firstTouch.location(in: view)
        previousPoint = firstTouch.previousLocation(in: view)

        if let rotation = rotationAngle {
            rotationValue += rotation.degrees / 360 * 100
            print("Rotation value is \(round(rotationValue))")
        }

        if round(rotationValue) == 100 {
            rotationValue = 0
            state = .recognized
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        currentPoint = nil
        previousPoint = nil
        rotationValue = 0
    }
}
