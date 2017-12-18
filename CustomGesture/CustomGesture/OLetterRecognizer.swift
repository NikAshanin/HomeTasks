import Foundation
import UIKit.UIGestureRecognizerSubclass

final class OLetterRecognizer: UIGestureRecognizer {
    private let strokePrecision: CGFloat = 8
    private var strokePart: UInt = 0
    private var firstTap: CGPoint?
    private let circleRadius: CGFloat = 150
    private var circleCenter: CGPoint = CGPoint(x: 0, y: 0)

    override func reset() {
        super.reset()
        strokePart = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Touches began.")
        super.touchesBegan(touches, with: event)

        guard touches.count == 1 else {
            state = .failed
            return
        }

        firstTap = touches.first?.location(in: view?.superview)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
        print("Touches ended.")
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
        circleCenter = CGPoint(x: superview.center.x, y: superview.center.y)

        if strokePart == 0 && !isPointOnCircle(currentPoint) &&
            circleCenter.x + circleRadius - currentPoint.x <= strokePrecision {
            strokePart = 1
        } else if strokePart == 1 && !isPointOnCircle(currentPoint) &&
            circleCenter.y + circleRadius - currentPoint.y <= strokePrecision {
            strokePart = 2
        } else if strokePart == 2 && !isPointOnCircle(currentPoint) &&
            circleCenter.x - circleRadius - currentPoint.x <= strokePrecision {
            strokePart = 3
        } else if strokePart == 3 && !isPointOnCircle(currentPoint) &&
            currentPoint.x - firstTap.x <= strokePrecision && currentPoint.y - firstTap.y <= strokePrecision {
            strokePart = 4
            state = .recognized
            print("recognized!")
        }
    }
}

extension OLetterRecognizer {
    func isPointOnCircle(_ currentPoint: CGPoint) -> Bool {
        return pow(currentPoint.x - circleCenter.x, 2) + pow(currentPoint.y - currentPoint.y, 2) == pow(circleRadius, 2)
    }
}
