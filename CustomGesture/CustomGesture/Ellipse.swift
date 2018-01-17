import UIKit

final class Ellipse {
    private var xRadius: CGFloat
    private var yRadius: CGFloat
    private var centerPoint: CGPoint
    private var stripeWidth: CGFloat

    init(centerPoint: CGPoint, xRadius: CGFloat, yRadius: CGFloat, stripeWidth: CGFloat) {
        self.centerPoint = centerPoint
        self.xRadius = xRadius
        self.yRadius = yRadius
        self.stripeWidth = stripeWidth
    }

    func contains(point: CGPoint) -> Bool {
        return pow(point.x - centerPoint.x, 2)/pow(xRadius + stripeWidth/2, 2)
            + pow(point.y - centerPoint.y, 2)/pow(yRadius + stripeWidth/2, 2) <= 1 &&
            pow(point.x - centerPoint.x, 2)/pow(xRadius - stripeWidth/2, 2)
            + pow(point.y - centerPoint.y, 2)/pow(yRadius - stripeWidth/2, 2) >= 1
    }
}
