import UIKit
import UIKit.UIGestureRecognizerSubclass

private extension CGFloat {
    var degrees: CGFloat {
        return self * 180 / CGFloat(Double.pi)
    }
}

final class ORecognizer: UIGestureRecognizer {
    private var midPoint: CGPoint
    private var innerX: CGFloat
    private var innerY: CGFloat
    private var firstAngle: CGFloat?
    private var outerX: CGFloat
    private var outerY: CGFloat
    private var strokePart: UInt = 0
    private var currentPoint: CGPoint?
    private var previousPoint: CGPoint?
    private var angle: CGFloat? {
        if let nowPoint = currentPoint {
            return angleForPoint(point: nowPoint)
        }
        return nil
    }
    private var squareX: CGFloat? {
        if let nowPoint = currentPoint {
            return distantionSquareForX(pointA: midPoint, andPointB: nowPoint)
        }
        return nil
    }
    private var squareY: CGFloat? {
        if let nowPoint = currentPoint {
            return distantionSquareForY(pointA: midPoint, andPointB: nowPoint)
        }
        return nil
    }

    init(midPoint: CGPoint,
         innerX: CGFloat,
         innerY: CGFloat,
         outerX: CGFloat,
         outerY: CGFloat,
         target: AnyObject?,
         action: Selector) {
        self.midPoint = midPoint
        self.innerX = innerX
        self.innerY = innerY
        self.outerX = outerX
        self.outerY = outerY
        super.init(target: target, action: action)
    }
    convenience init(midPoint: CGPoint, target: AnyObject?, action: Selector) {
        self.init(midPoint: midPoint, innerX: 80, innerY: 135, outerX: 150, outerY: 200, target: target, action: action)
    }
    func angleForPoint(point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + CGFloat(Double.pi)/2
        if angle < 0 {
            angle += CGFloat(Double.pi)*2
        }
        return angle
    }
    func distantionSquareForX(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dx = CGFloat(pointA.x - pointB.x)
        return dx*dx
    }
    func distantionSquareForY(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dy = CGFloat(pointA.y - pointB.y)
        return dy*dy
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let x = squareX, let y = squareY {
            if (x / (innerX * innerX) + y / (innerY * innerY)) <= 1 {
                state = .failed
            }
            if (x / (outerX * outerX) + y / (outerY * outerY)) > 1 {
                state = .failed
            }
        }
        guard state != .failed, let firstTouch = touches.first else {
            return
        }
        currentPoint = firstTouch.location(in: view)
        previousPoint = firstTouch.previousLocation(in: view)
        guard let deg = angle?.degrees, let first = firstAngle else {
            return
        }
        if strokePart == 0 &&
            deg > CGFloat(225) && deg <= CGFloat(315) {
            firstAngle = deg
            print("continue 1")
            strokePart = 1
        } else if strokePart == 1 &&
            deg > CGFloat(315) && deg <= CGFloat(360) ||
                deg >= CGFloat(0) && deg <= CGFloat(45) {
            strokePart = 2
            print("continue 2")
        } else if strokePart == 2 &&
            deg > CGFloat(45) && deg <= CGFloat(135) {
            strokePart = 3
            print("continue 3")
        } else if strokePart == 3 &&
            deg > CGFloat(135) && deg <= CGFloat(225) {
            strokePart = 4
            print("continue 4")
        } else if strokePart == 4 &&
            deg > CGFloat(225) && deg <= CGFloat(first) {
            strokePart = 5
            state = .recognized
            print("'O' recognized")
        }
    }
    override func reset() {
        super.reset()
        strokePart = 0
        previousPoint = nil
        currentPoint = nil
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }
}
