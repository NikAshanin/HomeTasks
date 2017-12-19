import Foundation
import UIKit.UIGestureRecognizerSubclass

final class OLetterRecognizer: UIGestureRecognizer {
    // MARK: properties
    private let strokePrecision: CGFloat = 5
    private var strokePart: UInt = 0
    private var firstTap: CGPoint?
    //Радиус и центр определены руками
    private let circleRadius: CGFloat = 150
    private let circleCenter: CGPoint = CGPoint(x: 187.5, y: 323.5)

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
            print("O recognized!")
        }
    }
}

extension OLetterRecognizer {
    func isPointOnCircle(_ currentPoint: CGPoint) -> Bool {
        return pow(currentPoint.x - circleCenter.x, 2) + pow(currentPoint.y - circleCenter.y, 2) <= pow(circleRadius, 2) * 0.2
    }
}
