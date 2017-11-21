import UIKit
import UIKit.UIGestureRecognizerSubclass

class ORecognizer: UIGestureRecognizer {
    // MARK: magic numbers
    // strokePart - этап выполнения
    private var strokePart: UInt = 0
    private var firstTap: CGPoint?

    override func reset() {
        super.reset()
        strokePart = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }
        firstTap = touches.first?.location(in: view?.superview)
        guard let firstTap = firstTap,
            abs(firstTap.x - ParamsForCalculating.centerPoint.x) <= ParamsForCalculating.strokePrecision
                && abs(firstTap.y - ParamsForCalculating.centerPoint.y
                    + ParamsForCalculating.xRadius) <= ParamsForCalculating.strokePrecision else {
                    return
        }
        guard abs(firstTap.x - ParamsForCalculating.centerPoint.x) <= ParamsForCalculating.strokePrecision
            && abs(firstTap.y - ParamsForCalculating.centerPoint.y
                + ParamsForCalculating.xRadius) <= ParamsForCalculating.strokePrecision else {
                state = .failed
                return
        }
        print("Touches Began")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
        print("touches ended")
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
        guard isPointOnRadius(currentPoint) else {
            print("failed with x = \(currentPoint.x) and y = \(currentPoint.y)")
            state = .failed
            return
        }
        if strokePart == 0
            && abs(ParamsForCalculating.centerPoint.x + ParamsForCalculating.xRadius
                - currentPoint.x) <= ParamsForCalculating.strokePrecision
            && isPointOnRadius(currentPoint) {
            print("part 1 complete")
            strokePart = 1
        } else if strokePart == 1
            && abs(ParamsForCalculating.centerPoint.y + ParamsForCalculating.yRadius
                - currentPoint.y) <= ParamsForCalculating.strokePrecision
            && isPointOnRadius(currentPoint) {
            strokePart = 2
            print("part 2 complete")
        } else if strokePart == 2
            && abs(ParamsForCalculating.centerPoint.x - ParamsForCalculating.xRadius
                - currentPoint.x) <= ParamsForCalculating.strokePrecision
            && isPointOnRadius(currentPoint) {
            strokePart = 3
            print("part 3 complete")
        } else if strokePart == 3
            && abs(currentPoint.y - firstTap.y) <= ParamsForCalculating.strokePrecision
            && abs(currentPoint.x - firstTap.x) <= ParamsForCalculating.strokePrecision
            && isPointOnRadius(currentPoint) {
            strokePart = 4
            state = .recognized
            print("zero recognized")
        }
    }

    // MARK: formula
    // x^2/a^2 + y^2/b^2 = 1
    func isPointOnRadius(_ currentPoint: CGPoint) -> Bool {
        return abs(pow(currentPoint.x, 2) / pow(ParamsForCalculating.xRadius, 2) +
            pow(currentPoint.y, 2) / pow(ParamsForCalculating.yRadius, 2) - 1) <= ParamsForCalculating.mathPrecision
    }
}
