import Foundation
import CoreGraphics

final class MathHelper {
    static func getDistance(from point1: CGPoint,
                            to point2: CGPoint) -> CGFloat {
        return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
    }

    static func getAngle(of point: CGPoint,
                         to center: CGPoint) -> CGFloat {
        let x = point.x - center.x
        let y = point.y - center.y
        var angle: CGFloat = 0.0
        if x > 0 {
            angle = atan(y / x)
        } else {
            angle = CGFloat.pi + atan(y / x)
        }
        return angle
    }

    static func convertAngle(angle: CGFloat,
                             by startAngle: CGFloat,
                             with clockWiseOrientation: Bool) -> CGFloat {
        if clockWiseOrientation {
            if angle < startAngle {
                return angle + CGFloat.pi * 2 - startAngle
            } else {
                return angle - startAngle
            }
        } else {
            return 2 * CGFloat.pi - convertAngle(angle: angle, by: startAngle, with: !clockWiseOrientation)
        }
    }
}
