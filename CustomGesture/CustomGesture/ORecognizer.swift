import UIKit
import UIKit.UIGestureRecognizerSubclass

let numberpi = CGFloat(Double.pi)
extension CGFloat {
    var degrees: CGFloat {
        return self * 180 / numberpi
    }
}

class ORecognizer: UIGestureRecognizer {
    var midPoint: CGPoint!
    var innerX: CGFloat!
    var innerY: CGFloat!
    var firstAngle: CGFloat!
    var outerX: CGFloat!
    var outerY: CGFloat!
    var strokePart: UInt = 0
    var currentPoint: CGPoint!
    var previousPoint: CGPoint!
    var angle: CGFloat! {
        if let nowPoint = currentPoint {
            return angleForPoint(point: nowPoint)
        }
        return nil
    }
    var sqrtX: CGFloat! {
        if let nowPoint = currentPoint {
            return distantionSqrtForX(pointA: midPoint, andPointB: nowPoint)
        }
        return nil
    }
    var sqrtY: CGFloat! {
        if let nowPoint = currentPoint {
            return distantionSqrtForY(pointA: midPoint, andPointB: nowPoint)
        }
        return nil
    }
    init(midPoint: CGPoint, innerX: CGFloat, innerY: CGFloat, outerX: CGFloat, outerY: CGFloat, target: AnyObject, action: Selector) {
        super.init(target: target, action: action)
        self.midPoint = midPoint
        self.innerX = innerX
        self.innerY = innerY
        self.outerX = outerX
        self.outerY = outerY
    }
    convenience init(midPoint: CGPoint, target: AnyObject?, action: Selector) {
        self.init(midPoint: midPoint, innerX: 80, innerY: 135, outerX: 150, outerY: 200, target: target!, action: action)
    }
    func angleForPoint(point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + numberpi/2
        if angle < 0 {
            angle += numberpi*2
        }
        return angle
    }
    func distantionSqrtForX(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dx = CGFloat(pointA.x - pointB.x)
        return dx*dx
    }
    func distantionSqrtForY(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
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
        if let x = sqrtX, let y = sqrtY {
            
            if (x / (innerX! * innerX!) + y / (innerY! * innerY!)) <= 1 {
                state = .failed
            }
            if (x / (outerX! * outerX!) + y / (outerY! * outerY!)) > 1 {
                state = .failed
            }
        }
        if state == .failed {
            return
        }
        if let firstTouch = touches.first {
            currentPoint = firstTouch.location(in: view)
            previousPoint = firstTouch.previousLocation(in: view)
        }
        if strokePart == 0 &&
            (angle?.degrees)! > CGFloat(225) && (angle?.degrees)! <= CGFloat(315) {
            firstAngle = angle?.degrees
            print("continue 1")
            strokePart = 1
        } else if strokePart == 1 &&
            ((angle?.degrees)! > CGFloat(315) && (angle?.degrees)! <= CGFloat(360) ||
                (angle?.degrees)! >= CGFloat(0) && (angle?.degrees)! <= CGFloat(45)) {
            strokePart = 2
            print("continue 2")
        } else if strokePart == 2 &&
            (angle?.degrees)! > CGFloat(45) && (angle?.degrees)! <= CGFloat(135) {
            strokePart = 3
            print("continue 3")
        } else if strokePart == 3 &&
            (angle?.degrees)! > CGFloat(135) && (angle?.degrees)! <= CGFloat(225) {
            strokePart = 4
            print("continue 4")
        } else if strokePart == 4 &&
            (angle?.degrees)! > CGFloat(225) && (angle?.degrees)! <= CGFloat(firstAngle!) {
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

