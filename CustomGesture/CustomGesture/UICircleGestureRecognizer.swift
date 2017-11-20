import Foundation
import UIKit.UIGestureRecognizerSubclass
import UIKit.UIScreen

final class UICircleGestureRecognizer: UIGestureRecognizer {
    
    typealias Seconds = Double
    
    var allCirclePoints: [CGPoint] = []
    var firstTap: CGPoint?
    let allowedTapTime: Seconds = 5
    private var timeOfFirstTap: Date?
    
    override func reset() {
        super.reset()
        allCirclePoints = []
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        guard touches.count == 1 else {
            state = .failed
            return
        }
        
        firstTap = touches.first?.location(in: view?.superview)
        timeOfFirstTap = Date()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        let count = countConformingPoints(in: allCirclePoints)
        
        if Double(count) > Double(allCirclePoints.count) * 0.98 {
            state = .recognized
        }
        
        reset()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard state != .failed && state != .recognized else {
            return
        }
        
        guard let superview = view?.superview,
            let timeOfFirstTap = timeOfFirstTap,
            let currentPoint = touches.first?.location(in: superview),
            let firstTap = firstTap else {
                return
        }
        
        let tapDuration = Date().timeIntervalSince(timeOfFirstTap)
        if tapDuration > allowedTapTime {
            state = .failed
        }
        
        let distance = calculateDistance(from: firstTap, to: currentPoint)
        if distance < 10 {
            touchesEnded(touches, with: event)  // can i do that? or which state should i use to force this method?
        }
        
        allCirclePoints.append(currentPoint)
    }
    
    private func calculateDistance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return sqrt(getSumOfSquares(of: p1, and: p2))
    }
    
    private func getSumOfSquares(of p1: CGPoint, and p2: CGPoint) -> CGFloat {
        return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)
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
        let innerRadius = outterRadius*0.25
        
        let filteredArray = array.filter { point in
            let sum = getSumOfSquares(of: point, and: origin)
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
    
}
