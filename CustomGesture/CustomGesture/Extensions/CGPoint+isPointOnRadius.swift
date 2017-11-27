import UIKit
extension CGPoint {
    // MARK: formula
    // x^2/a^2 + y^2/b^2 = 1
    static func isPointOnRadius(_ currentPoint: CGPoint) -> Bool {
        return abs(pow(currentPoint.x, 2) / pow(ParamsForCalculating.xRadius, 2) +
            pow(currentPoint.y, 2) / pow(ParamsForCalculating.yRadius, 2) - 1) <= ParamsForCalculating.mathPrecision
    }
}
