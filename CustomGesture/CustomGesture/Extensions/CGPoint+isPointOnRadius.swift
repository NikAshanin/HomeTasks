import UIKit
extension CGPoint {
    // MARK: formula
    // x^2/a^2 + y^2/b^2 = 1

    var isOnRadius: Bool {
        return abs(pow(x, 2) / pow(ParamsForCalculating.xRadius, 2) +
            pow(y, 2) / pow(ParamsForCalculating.yRadius, 2) - 1) <= ParamsForCalculating.mathPrecision
    }
}
