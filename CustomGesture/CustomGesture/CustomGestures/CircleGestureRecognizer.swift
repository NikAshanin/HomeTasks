import UIKit.UIGestureRecognizerSubclass

final class CircleGestureRecognizer: UIGestureRecognizer {

    private let center: CGPoint
    private let innerRadius: CGFloat
    private let outerRadius: CGFloat

    private var startAngle: CGFloat?
    private var isClockwiseRotation: Bool?
    private var halfPathCheck = false
    private let halfPathDistance: CGFloat = 0.5 // in radians

    init(center: CGPoint,
         innerRadius: CGFloat,
         outerRadius: CGFloat,
         target: AnyObject?,
         action: Selector?) {

        self.center = center
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        super.init(target: target, action: action)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        print("touches began")
        guard let firstTouch = touches.first else {
            return
        }
        let touchPoint = firstTouch.location(in: view)

        checkDistanceFromCenter(touchPoint: touchPoint)
        startAngle = touchPoint.getAngle(with: center)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let firstTouch = touches.first, state != .failed else {
            return
        }
        let currentPoint = firstTouch.location(in: view)
        let previousPoint = firstTouch.previousLocation(in: view)
        let currentAngle = currentPoint.getAngle(with: center)
        let previousAngle = previousPoint.getAngle(with: center)

        checkDistanceFromCenter(touchPoint: currentPoint)

        guard let clockwiseRotation = isClockwiseRotation else {
            if currentAngle > previousAngle && currentAngle - previousAngle < .pi {
                isClockwiseRotation = true
            }
            if currentAngle < previousAngle && currentAngle - previousAngle > -.pi {
                isClockwiseRotation = false
            }
            return
        }
        guard let startAngle = self.startAngle else {
            return
        }
        let currentValue = MathHelper.convertAngle(angle: currentAngle, by: startAngle, with: clockwiseRotation)
        if abs(currentValue - .pi) < halfPathDistance {
            halfPathCheck = true
        }
        if currentValue < .pi {
            halfPathCheck = false
        }
        if currentValue >= 6.0 && halfPathCheck {
            print("touch recognized")
            state = .recognized
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }

    override func reset() {
        super.reset()
        startAngle = nil
        isClockwiseRotation = nil
        halfPathCheck = false
        print("reset")
    }

    func checkDistanceFromCenter(touchPoint: CGPoint) {
        let distance = touchPoint.getDistance(to: center)
        if distance < innerRadius || distance > outerRadius {
            print("failed")
            state = .failed
        }
    }
}
