import UIKit
import UIKit.UIGestureRecognizerSubclass

final class ORecognizer: UIGestureRecognizer {
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
                        state = .failed
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
        guard CGPoint.isPointOnRadius(currentPoint) else {
            print("failed with x = \(currentPoint.x) and y = \(currentPoint.y)")
            state = .failed
            return
        }
        if strokePart == 0
            && abs(ParamsForCalculating.centerPoint.x + ParamsForCalculating.xRadius
                - currentPoint.x) <= ParamsForCalculating.strokePrecision
            && CGPoint.isPointOnRadius(currentPoint) {
            print("part 1 complete")
            strokePart = 1
        } else if strokePart == 1
            && abs(ParamsForCalculating.centerPoint.y + ParamsForCalculating.yRadius
                - currentPoint.y) <= ParamsForCalculating.strokePrecision
            && CGPoint.isPointOnRadius(currentPoint) {
            strokePart = 2
            print("part 2 complete")
        } else if strokePart == 2
            && abs(ParamsForCalculating.centerPoint.x - ParamsForCalculating.xRadius
                - currentPoint.x) <= ParamsForCalculating.strokePrecision
            && CGPoint.isPointOnRadius(currentPoint) {
            strokePart = 3
            print("part 3 complete")
        } else if strokePart == 3
            && abs(currentPoint.y - firstTap.y) <= ParamsForCalculating.strokePrecision
            && abs(currentPoint.x - firstTap.x) <= ParamsForCalculating.strokePrecision
            && CGPoint.isPointOnRadius(currentPoint) {
            strokePart = 4
            state = .recognized
            print("zero recognized")
        }
    }
}
