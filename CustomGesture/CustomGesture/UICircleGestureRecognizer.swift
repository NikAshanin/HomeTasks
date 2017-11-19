import Foundation
import UIKit.UIGestureRecognizerSubclass
import UIKit.UIScreen

final class UICircleGestureRecognizer: UIGestureRecognizer  {
    
    var allCirclePoints: [CGPoint] = [] {
        didSet {
            if allCirclePoints.count > 1000 {
                state = .failed
            }
        }
    }
    var firstTap: CGPoint?
    
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        let count = checkPoints(in: allCirclePoints)
        
        print("\(count) из \(allCirclePoints.count)")
        
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
            let currentPoint = touches.first?.location(in: superview),
            let firstTap = firstTap else {
                return
        }
        
        let distance = calculateDistance(from: firstTap, to: currentPoint)
        
        if distance < 10 {
            touchesEnded(touches, with: event)  // can i do that? or witch state should i use?
        }
        
        allCirclePoints.append(currentPoint)
    }
    
    private func calculateDistance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return sqrt( (p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
    }
    
    private func findOrigin() -> CGPoint {
        var x: CGFloat = 0
        var y: CGFloat = 0
        for point in allCirclePoints {
            x += point.x
            y += point.y
        }
        let count: CGFloat = CGFloat(allCirclePoints.count)
        return CGPoint(x: x/count, y: y/count)
    }
    
    private func checkPoints(in array: [CGPoint]) -> UInt {
        var count: UInt = 0
        let origin = findOrigin()
        let radius = getRad(from: origin)
        let outterRadius = radius*radius
        let innerRadius = outterRadius*0.25
        for point in array {
            let coords = (point.x-origin.x)*(point.x-origin.x) + (point.y-origin.y)*(point.y-origin.y)
            if coords < outterRadius, coords > innerRadius {
                count+=1
            }
        }
        return count
    }
    
    func getRad(from origin: CGPoint) -> CGFloat {
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
