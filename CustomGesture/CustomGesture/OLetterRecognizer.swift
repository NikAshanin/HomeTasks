import Foundation
import UIKit.UIGestureRecognizerSubclass

final class OLetterRecognizer: UIGestureRecognizer {
    private static let threshold: CGFloat = 30
    private var ellipse = Ellipse(centerPoint: CGPoint(x: 187, y: 320),
                                  xRadius: 95,
                                  yRadius: 150,
                                  stripeWidth: threshold)
    private var firstPoint: CGPoint?
    private var directions: [Direction] = []

    override func reset() {
        super.reset()
        directions.removeAll()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }
        firstPoint = touches.first?.location(in: view?.superview)
        guard let firstPoint = firstPoint, ellipse.contains(point: firstPoint) else {
            state = .failed
            return
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard state != .failed && state != .recognized else {
            return
        }
        guard let superview = view?.superview,
            let firstPoint = firstPoint,
            let currentTouch = touches.first,
            let previousPoint = touches.first?.previousLocation(in: superview) else {
                return
        }
        let currentPoint = currentTouch.location(in: superview)
        if currentPoint.x > previousPoint.x && currentPoint.y > previousPoint.y {
            directions.appendIfNotEqualToLastElement(newElement: .toBottomRight)
        } else if currentPoint.x < previousPoint.x && currentPoint.y > previousPoint.y {
            directions.appendIfNotEqualToLastElement(newElement: .toBottomLeft)
        } else if currentPoint.x < previousPoint.x && currentPoint.y < previousPoint.y {
            directions.appendIfNotEqualToLastElement(newElement: .toTopLeft)
        } else if currentPoint.x > previousPoint.x && currentPoint.y < previousPoint.y {
            directions.appendIfNotEqualToLastElement(newElement: .toTopRight)
        }
        if !ellipse.contains(point: currentPoint) {
            state = .failed
        }
        if Set(directions).count == Direction.enumCount
            && directions.count <= 5
            && firstPoint.distanceTo(currentPoint) <= OLetterRecognizer.threshold / 2 {
            state = .recognized
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }
}

fileprivate extension Array where Element: Equatable {
    mutating func appendIfNotEqualToLastElement(newElement: Element) {
        if let lastElement = last, lastElement == newElement {
            return
        } else {
            append(newElement)
        }
    }
}

fileprivate extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
}
