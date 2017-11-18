import Foundation

extension Double {
    public var factorial: Double {
        let roundedDouble = rounded()
        return roundedDouble == 1.0 ? roundedDouble : roundedDouble * (roundedDouble - 1).factorial
    }

    func logY(_ val: Double) -> Double {
        return log(val)/log(self)
    }

    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
