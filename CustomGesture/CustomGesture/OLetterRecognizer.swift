import Foundation
import UIKit.UIGestureRecognizerSubclass

final class OLetterRecognizer: UIGestureRecognizer {
    private enum Direction {
        case toBottomRight
        case toBottomLeft
        case toTopRight
        case toTopLeft

        static let enumCount = 4
    }

    private let accuracy: CGFloat = 50
    private var firstTap: CGPoint?
    private var allTouchesPoints: [CGPoint] = []
    private var directions: [Direction] = []

    override func reset() {
        super.reset()
        directions.removeAll()
        allTouchesPoints.removeAll()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }
        firstTap = touches.first?.location(in: view?.superview)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard state != .failed && state != .recognized else {
            return
        }
        guard let superview = view?.superview,
            let currentTouch = touches.first,
            let previousPoint = touches.first?.previousLocation(in: superview) else {
                return
        }
        let currentPoint = currentTouch.location(in: superview)
        allTouchesPoints.append(currentPoint)
        var isDirectionChanged: Bool = false
        if currentPoint.x > previousPoint.x && currentPoint.y > previousPoint.y {
            isDirectionChanged = directions.appendIfNotEqualToLastElement(newElement: .toBottomRight)
        } else if currentPoint.x < previousPoint.x && currentPoint.y > previousPoint.y {
            isDirectionChanged = directions.appendIfNotEqualToLastElement(newElement: .toBottomLeft)
        } else if currentPoint.x < previousPoint.x && currentPoint.y < previousPoint.y {
            isDirectionChanged = directions.appendIfNotEqualToLastElement(newElement: .toTopLeft)
        } else if currentPoint.x > previousPoint.x && currentPoint.y < previousPoint.y {
            isDirectionChanged = directions.appendIfNotEqualToLastElement(newElement: .toTopRight)
        }
        if isDirectionChanged {
            if directions.count > 5 {
                state = .failed
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        guard let superview = view?.superview, let lastPoint = touches.first?.location(in: superview),
            let firstTap = firstTap else {
                return
        }
        let rightSide =  allTouchesPoints.max { $0.x < $1.x }?.x ?? 0
        let leftSide =  allTouchesPoints.max { $0.x > $1.x }?.x ?? 0
        let bottomSide =  allTouchesPoints.max { $0.y < $1.y }?.y ?? 0
        let topSide =  allTouchesPoints.max { $0.y > $1.y }?.y ?? 0
        let xRadius = (rightSide - leftSide)/2
        let yRadius = (bottomSide - topSide)/2
        let centerPoint = CGPoint(x: xRadius + leftSide, y: yRadius + topSide)
        if xRadius > accuracy && yRadius > accuracy
            && Set(directions).count == Direction.enumCount
            && firstTap.distanceTo(lastPoint) < accuracy
            && allTouchesPoints.index(where: {
                $0.isInEllipseWith(centerPoint: centerPoint, xRadius: xRadius - accuracy/2, yRadius: yRadius - accuracy/2)
            }) == nil
            && allTouchesPoints.index(where: {
                !$0.isInEllipseWith(centerPoint: centerPoint, xRadius: xRadius + accuracy/2, yRadius: yRadius + accuracy/2)
            }) == nil {
            state = .recognized
        }
        reset()
    }
}

fileprivate extension Array where Element: Equatable {
    mutating func appendIfNotEqualToLastElement(newElement: Element) -> (Bool) {
        if let lastElement = self.last, lastElement == newElement {
            return false
        } else {
            self.append(newElement)
            return true
        }
    }
}

fileprivate extension CGPoint {
    func isInEllipseWith(centerPoint: CGPoint, xRadius: CGFloat, yRadius: CGFloat) -> (Bool) {
        return pow(self.x - centerPoint.x, 2)/pow(xRadius, 2) + pow(self.y - centerPoint.y, 2)/pow(yRadius, 2) <= 1
    }
    func distanceTo(_ point: CGPoint) -> (CGFloat) {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}
