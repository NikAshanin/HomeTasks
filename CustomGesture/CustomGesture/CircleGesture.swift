import UIKit.UIGestureRecognizerSubclass

final class CircleRecognizer: UIGestureRecognizer {
    private let strokePrecision: CGFloat = 80
    private var firstTap: CGPoint?
    private var centerCircle = CGPoint()
    private var previousPoint: CGPoint?
    private var radius: CGFloat = 0
    private var circleParth: Int = 0
    private var currentAngle: CGFloat = 0
    private var startAngle: CGFloat = 0
    private var circleState: Int = 0

    func setCircle(center: CGPoint, radius: CGFloat) {
        self.radius = radius
        self.centerCircle = center
    }

    override func reset() {
        currentAngle = 0
        startAngle = 0
        circleState = 0
        previousPoint = nil
        firstTap = nil
        super.reset()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Touches Began")
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }

        firstTap = touches.first?.location(in: view?.superview)

        guard let startPoint = firstTap else {
            state = .failed
            return
        }
        startAngle = angleForPoint(startPoint)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
        print("Touches Ended")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard let superview = view?.superview,
            let currentPoint = touches.first?.location(in: superview) else {
                state = .failed
                return
        }
        let xPos = currentPoint.x - (centerCircle.x )
        let yPos = currentPoint.y - (centerCircle.y )
        let currentPosition = xPos * xPos + yPos * yPos
        if currentPosition < ((radius * radius) + (strokePrecision * strokePrecision))
            && currentPosition > ((radius * radius) - (strokePrecision * strokePrecision)) {
            if previousPoint == nil {
                previousPoint = currentPoint
                return
            }
            guard let startPoint = firstTap else {
                state = .failed
                return
            }
            currentAngle = angleBetween(pointA: startPoint, pointB: currentPoint)
            print(currentAngle)
            if (currentAngle > 3.2 && currentAngle < 3.5)
                || (currentAngle < -3.2 && currentAngle > -3.5)
                && circleState == 0 {
                circleState = 1
            }

            if circleState == 1 &&
                (currentAngle > -0.1 && currentAngle < 0.1) {
                state = .recognized
            }
        } else {
            print("Gesture failed")
            state = .failed
        }
    }
}

// MARK: some algebra
extension CircleRecognizer {
    private func angleForPoint(_ point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - centerCircle.x), Float(point.y - centerCircle.y))) + .pi/2
        if angle < 0 {
            angle += .pi*2
        }
        return angle
    }

    private func angleBetween(pointA: CGPoint, pointB: CGPoint ) -> CGFloat {
        return angleForPoint(pointA) - angleForPoint(pointB)
    }
}
