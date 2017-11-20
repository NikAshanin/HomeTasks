import UIKit
import UIKit.UIGestureRecognizerSubclass

class ORecognizer: UIGestureRecognizer {
    // MARK: magic numbers
    // strokePrecision - допускаемая погрешность (отклонение)
    private let strokePrecision: CGFloat = 20
    // mathPrecision - допускаемая погрешность вычислений
    private let mathPrecision: CGFloat = 10.5
    // strokePart - этап выполнения
    private var strokePart: UInt = 0
    private var firstTap: CGPoint?
    // центр круга, значения x  и  y замерены
    private let centerPoint = CGPoint(x: 197, y: 320)
    // a - радиус по оси x, b - радиус по оси y
    private let xRadius: CGFloat = 160, yRadius: CGFloat = 160

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
            abs(firstTap.x - centerPoint.x) <= strokePrecision
                && abs(firstTap.y - centerPoint.y + xRadius) <= strokePrecision else {
                    return
        }
        guard abs(firstTap.x - centerPoint.x) <= strokePrecision
            && abs(firstTap.y - centerPoint.y + xRadius) <= strokePrecision else {
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
            && abs(centerPoint.x + xRadius - currentPoint.x) <= strokePrecision
            && isPointOnRadius(currentPoint) {
            print("part 1 complete")
            strokePart = 1
        } else if strokePart == 1
            && abs(centerPoint.y + yRadius - currentPoint.y) <= strokePrecision
            && isPointOnRadius(currentPoint) {
            strokePart = 2
            print("part 2 complete")
        } else if strokePart == 2
            && abs(centerPoint.x - xRadius - currentPoint.x) <= strokePrecision
            && isPointOnRadius(currentPoint) {
            strokePart = 3
            print("part 3 complete")
        } else if strokePart == 3
            && abs(currentPoint.y - firstTap.y) <= strokePrecision
            && abs(currentPoint.x - firstTap.x) <= strokePrecision
            && isPointOnRadius(currentPoint) {
            strokePart = 4
            state = .recognized
            print("zero recognized")
        }
    }

    // MARK: formula
    // x^2/a^2 + y^2/b^2 = 1
    func isPointOnRadius(_ currentPoint: CGPoint) -> Bool {
        return abs(pow(currentPoint.x, 2) / pow(xRadius, 2) +
            pow(currentPoint.y, 2) / pow(yRadius, 2) - 1) <= mathPrecision
    }
}
