import UIKit.UIGestureRecognizerSubclass

final class CircleGestureRecognizer: UIGestureRecognizer {

    private var circleView: CircleView

    private var startAngle: CGFloat?
    private var isClockwiseRotation: Bool?
    private var halfPathCheck = false
    private let halfPathDistance: CGFloat = 0.5 // in radians

    init(circleView: CircleView, target: AnyObject?, action: Selector?) {
        self.circleView = circleView
        super.init(target: target, action: action)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        print("touches began")
        guard let firstTouch = touches.first else {
            return
        }
        let touchPoint = firstTouch.location(in: circleView)

        checkDistanceFromCenter(touchPoint: touchPoint)
        startAngle = MathHelper.getAngle(of: touchPoint, to: circleView.center)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let firstTouch = touches.first, state != .failed else {
            return
        }
        let currentPoint = firstTouch.location(in: circleView)
        let previousPoint = firstTouch.previousLocation(in: circleView)
        let currentAngle = MathHelper.getAngle(of: currentPoint, to: circleView.center)
        let previousAngle = MathHelper.getAngle(of: previousPoint, to: circleView.center)

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
        let distance = MathHelper.getDistance(from: touchPoint, to: circleView.center)
        if distance < circleView.innerRadius || distance > circleView.outerRadius {
            print("failed")
            state = .failed
        }
    }
}
