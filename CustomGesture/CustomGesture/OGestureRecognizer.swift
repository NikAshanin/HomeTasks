import Foundation
import UIKit.UIGestureRecognizerSubclass

final class OGestureRecognizer: UIGestureRecognizer {
    private var width: CGFloat = 0
    private let height: CGFloat
    private let center: CGPoint
    private var firstTap: CGPoint?
    private var previousState = CGPoint()

    private enum StatesOfCircle {
        case firstCircleQuarter
        case secondCircleQuarter
        case thirdCircleQuarter
        case forthCircleQuarter
    }

    private var circleState: StatesOfCircle
    var currentAngle: CGFloat = 0
    var around: CGFloat = 20

    init(width: CGFloat, height: CGFloat, center: CGPoint, target: Any?, action: Selector) {
        self.width = width
        self.height = height
        self.center = center
        circleState = StatesOfCircle.firstCircleQuarter
        super.init(target: target, action: action)
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
        circleState = StatesOfCircle.firstCircleQuarter
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

        if circleState == StatesOfCircle.firstCircleQuarter {
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

        guard isCurrentPointOnEllipse(point: currentPoint) else {
            state = .failed
            return
        }

        if circleState == StatesOfCircle.firstCircleQuarter && currentAngle >= 90 {
            circleState = StatesOfCircle.secondCircleQuarter
            previousState = currentPoint
            currentAngle = 0
        } else if circleState == StatesOfCircle.secondCircleQuarter && currentAngle >= 90 {
            circleState = StatesOfCircle.thirdCircleQuarter
            previousState = currentPoint
            currentAngle = 0
        } else if circleState == StatesOfCircle.thirdCircleQuarter && currentAngle >= 90 {
            circleState = StatesOfCircle.forthCircleQuarter
            previousState = currentPoint
            currentAngle = 0
        } else if circleState == StatesOfCircle.forthCircleQuarter && currentAngle >= 90 &&
                  distance(currentPoint, firstTap) <= around {
            state = .recognized
        }
    }

    public func isCurrentPointOnEllipse(point: CGPoint) -> Bool {
        var newPoint = CGPoint()
        newPoint.x = point.x - center.x
        newPoint.y = point.y - center.y
        let ellipse = (newPoint.x*newPoint.x)/(width*width) + (newPoint.y*newPoint.y)/(height*height)
        return ellipse <= 1.3 && ellipse >= 0.7
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
