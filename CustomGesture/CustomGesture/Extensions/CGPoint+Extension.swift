import Foundation
import CoreGraphics

extension CGPoint {
    func getDistance(to point: CGPoint) -> CGFloat {
        return sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y))
    }

    func getAngle(with center: CGPoint) -> CGFloat {
        let deltaX = x - center.x
        let deltaY = y - center.y
        var angle: CGFloat = 0.0
        if deltaX > 0 {
            angle = atan(deltaY / deltaX)
        } else {
            angle = CGFloat.pi + atan(deltaY / deltaX)
        }
        return angle
    }
}
