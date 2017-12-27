import Foundation

extension Double {
    var trigOperations: Set<String> {
        return ["sin-1", "sinh-1", "cos-1",
                "cosh-1", "tan-1", "tanh-1",
                "sinh", "sin", "cos",
                "cosh", "tan", "tanh"]
    }

    var factorial: Double {
        let roundedDouble = rounded()
        return roundedDouble == 1.0 ? roundedDouble : roundedDouble * (roundedDouble - 1).factorial
    }

    func logY(_ val: Double) -> Double {
        return log(val)/log(self)
    }

    func formatToDergeeOrRad(operation: String) -> Double {
        var newNumber = self
        if trigOperations.contains(operation) {
            newNumber = self.degreesToRadians
        }
        return newNumber
    }

    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
