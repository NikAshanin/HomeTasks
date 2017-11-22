import UIKit.UIGestureRecognizerSubclass

final class CircleGestureRecognizer: UIGestureRecognizer {

    private var innerRadius: CGFloat?
    private var outerRadius: CGFloat?
    private let midPoint: CGPoint
    private var radius: CGFloat? {
        if let newPoint = currentPoint {
            return midPoint.distanceTo(pointB: newPoint)
        }
        return nil
    }

    init(midPoint: CGPoint, innerRadius: CGFloat?, outerRadius: CGFloat?, target: AnyObject?, action: Selector) {
        self.midPoint = midPoint
        super.init(target: target, action: action)
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
    }

    private var currentPoint: CGPoint?
    private var previousPoint: CGPoint?
    private var currentValue: CGFloat = 0
    private var rotation: CGFloat? {
        guard let currentPoint = currentPoint,
            let previousPoint = previousPoint else {
                return nil
        }
        let rotation = previousPoint.angleTo(pointB: currentPoint, with: midPoint)
        print("rotation = \(rotation / (.pi * 2) * 100)")
        return rotation
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("touches began")
        guard let firstTouch = touches.first,
            let innerRadius = innerRadius,
            let distance = radius,
            let outerRadius = outerRadius else {
                return
        }

        currentPoint = firstTouch.location(in: view)

        if distance < innerRadius || distance > outerRadius {
            state = .failed
        }
    }

    override func reset() {
        super.reset()
        currentValue = 0
        currentPoint = nil
        previousPoint = nil
        print("reset")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        print("touches moved")
        guard state != .failed,
            let firstTouch = touches.first else {
                return
        }
        currentPoint = firstTouch.location(in: view)
        previousPoint = firstTouch.previousLocation(in: view)

        guard let rotation = rotation else {
            return
        }
        if let innerRadius = innerRadius,
            let outerRadius = outerRadius,
            let distance = radius {
            print("innerRadius = \(innerRadius) distance = \(distance) outerRadius = \(outerRadius)")
            if distance < innerRadius || distance > outerRadius {
                state = .failed
            }
        }
        currentValue += rotation / (2 * .pi) * 100
        print(currentValue)
        if currentValue >= 100 || currentValue <= -100 {
            print("touch recognized")
            state = .recognized
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }

}

private extension CGPoint {
    func distanceTo(pointB: CGPoint) -> CGFloat {
        let x = self.x - pointB.x
        let y = self.y - pointB.y
        return CGFloat(sqrt(x * x + y * y))
    }

    private func angle(from midPoint: CGPoint) -> CGFloat {
        let angle = atan2(self.x - midPoint.x, self.y - midPoint.y) + .pi / 2
        print("angle = \(angle)")
        return angle
    }

    func angleTo(pointB: CGPoint, with midPoint: CGPoint) -> CGFloat {
        var angle = self.angle(from: midPoint) - pointB.angle(from: midPoint)
        if angle > .pi {
            angle -= .pi * 2
        } else if angle < -.pi {
            angle += .pi * 2
        }
        return angle
    }
}
