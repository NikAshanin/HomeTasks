import Foundation

final class PendingBinaryOperation {

    let function: (Double, Double) -> Double
    let firstOperand: Double

    init(function: @escaping (Double, Double) -> Double, firstOperand: Double) {
        self.function = function
        self.firstOperand = firstOperand
    }

    func perform(with secondOperand: Double) -> Double {
        return function(firstOperand, secondOperand)
    }
}
