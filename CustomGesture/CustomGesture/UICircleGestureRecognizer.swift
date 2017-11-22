import Foundation
import UIKit.UIGestureRecognizerSubclass
import UIKit.UIScreen

final class UICircleGestureRecognizer: UIGestureRecognizer {

    typealias Percents = Double

    var allCirclePoints: [CGPoint] = []
    var firstTap: CGPoint?
    private var hasBeenFar = false

    override func reset() {
        super.reset()
        allCirclePoints = []
        hasBeenFar = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
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
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        guard state != .failed, state != .recognized else {
            return
        }

        guard let superview = view?.superview,
            let currentPoint = touches.first?.location(in: superview),
            let firstTap = firstTap else {
                return
        }

        let distance = calculateDistance(from: firstTap, to: currentPoint)

        if !hasBeenFar, distance > 10 {
            hasBeenFar = true
        }

        if hasBeenFar, distance < 10 {
            analizePoints()
            if state != .recognized {
                state = .failed
            }
        }

        allCirclePoints.append(currentPoint)
    }

    private func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(sumOfSquares(of: point1, and: point2))
    }

    private func sumOfSquares(of point1: CGPoint, and point2: CGPoint) -> CGFloat {
        return (point2.x - point1.x) * (point2.x - point1.x) + (point2.y - point1.y) * (point2.y - point1.y)
    }

    private func findOrigin() -> CGPoint {
        var x: CGFloat = 0
        var y: CGFloat = 0
        allCirclePoints.forEach { point in
            x += point.x
            y += point.y
        }
        let count: CGFloat = CGFloat(allCirclePoints.count)
        return CGPoint(x: x/count, y: y/count)
    }

    private func countConformingPoints(in array: [CGPoint]) -> Int {
        let origin = findOrigin()
        let radius = getRadius(from: origin)
        let outterRadius = radius*radius
        let innerRadius = outterRadius * 0.25
        let filteredArray = array.filter { point in
            let sum = sumOfSquares(of: point, and: origin)
            if sum < outterRadius, sum > innerRadius {
                return true
            }
            return false
        }
        return filteredArray.count
    }

    private func getRadius(from origin: CGPoint) -> CGFloat {
        var maxDistance: CGFloat = -1
        for point in allCirclePoints {
            let currentaDistance = calculateDistance(from: origin, to: point)
            if  currentaDistance > maxDistance {
                maxDistance = currentaDistance
            }
        }
        return maxDistance
    }

    private func analizePoints() {
        let count = countConformingPoints(in: allCirclePoints)

        let accuracy: Percents = 98

        if Double(count)/Double(allCirclePoints.count) * 100 > accuracy {
            state = .recognized
        }
    }
}
