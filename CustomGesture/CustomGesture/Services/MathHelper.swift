import Foundation
import CoreGraphics

final class MathHelper {
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
