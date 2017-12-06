import Foundation
import UIKit.UIGestureRecognizerSubclass

class OGestureRecognizer: UIGestureRecognizer {
    private var width: CGFloat = 0
    private var heigh: CGFloat = 0
    private var center: CGPoint = CGPoint()
    var trackedTouch: UITouch?
    var firstTap: CGPoint?
    var previousState: CGPoint = CGPoint()
    var stateOfCircle: Int = 0
    var currentAngle: CGFloat = 0
    var around: CGFloat = 20

    init(width: CGFloat, heigh: CGFloat, center: CGPoint, target: Any?, action: Selector) {
        super.init(target: target, action: action)
        self.width = width
        self.heigh = heigh
        self.center = center
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard touches.count == 1 else {
            state = .failed
            return
        }
        firstTap = touches.first?.location(in: view?.superview)
    }

    override func reset() {
        super.reset()
        stateOfCircle = 0
        currentAngle = 0
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard state != .failed && state != .recognized else {
            return
        }

        guard let superview = view?.superview,
                let currentPoint = touches.first?.location(in: superview),
                let firstTap = firstTap else {
                return
        }

        if stateOfCircle == 0 {
            previousState = firstTap
        }

        let lastAngle = currentAngle
        currentAngle = angle(aSide: distance(center, currentPoint),
                             bSide: distance(center, previousState),
                             cSide: distance(previousState, currentPoint))

        guard lastAngle < currentAngle else {
            state = .failed
            return
        }

        guard calculate(point: currentPoint) else {
            state = .failed
            return
        }

        if stateOfCircle == 0 && currentAngle >= 90 {
            stateOfCircle = 1
            previousState = currentPoint
            currentAngle = 0
        } else if stateOfCircle == 1 && currentAngle >= 90 {
            stateOfCircle = 2
            previousState = currentPoint
            currentAngle = 0
        } else if stateOfCircle == 2 && currentAngle >= 90 {
            stateOfCircle = 3
            previousState = currentPoint
            currentAngle = 0
        } else if stateOfCircle == 3 && currentAngle >= 90 &&
                  distance(currentPoint, firstTap) <= around {
            stateOfCircle = 4
            state = .recognized
        }
    }

    public func calculate(point: CGPoint) -> Bool {
        var newPoint = CGPoint()
        newPoint.x = point.x - center.x
        newPoint.y = point.y - center.y
        let ellipse = (newPoint.x*newPoint.x)/(width*width) + (newPoint.y*newPoint.y)/(heigh*heigh)
        if ellipse <= 1.3 && ellipse >= 0.7 {
            return true
        } else {
            return false
        }
    }

    public func angle(aSide: CGFloat, bSide: CGFloat, cSide: CGFloat) -> CGFloat {
        let x = (aSide*aSide+bSide*bSide-cSide*cSide)/(2*aSide*bSide)
        let radius = acos(x)*180/CGFloat.pi
        return radius
    }

    func distance(_ aSide: CGPoint, _ bSide: CGPoint) -> CGFloat {
        let xDist = aSide.x - bSide.x
        let yDist = aSide.y - bSide.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}
