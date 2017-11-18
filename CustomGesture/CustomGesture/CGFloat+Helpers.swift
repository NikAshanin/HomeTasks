import UIKit

extension CGFloat {
    var degrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    var radians: CGFloat {
        return self * CGFloat.pi / 180
    }
    var rad2deg: CGFloat {
        return degrees
    }
    var deg2rad: CGFloat {
        return radians
    }
}
