import Foundation

final class CalculatorService {
    var isRadian = true
    var flagForStack = true
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var operations: [String: Operation] =
        [
            "Rand": .rand { Double(arc4random()) / Double(UInt32.max) },
            "e": .constant(M_E),
            "π": .constant(.pi),
            "√x": .unary { sqrt($0) },
            "∛x": .unary { pow($0, 1/3) },
            "%": .unary { $0 / 100 },
            "+/-": .unary { -$0 },
            "x^2": .unary { pow($0, 2) },
            "x^3": .unary { pow($0, 3) },
            "e^x": .unary { pow(M_E, $0) },
            "10^x": .unary { pow(10, $0) },
            "2^x": .unary { pow(2, $0) },
            "x!": .unary { $0.factorial() },
            "sinh^-1": .unary(asinh),
            "cosh^-1": .unary(acosh),
            "tanh^-1": .unary(atanh),
            "ln": .unary(log),
            "log10": .unary(log10),
            "log2": .unary(log2),
            "1/x": .unary { 1 / $0 },
            "sin": .trigonometry(sin),
            "cos": .trigonometry(cos),
            "tan": .trigonometry(tan),
            "sinh": .trigonometry(sinh),
            "cosh": .trigonometry(cosh),
            "tanh": .trigonometry(tanh),
            "sin^-1": .inverseTrigonometry(asin),
            "cos^-1¹": .inverseTrigonometry(acos),
            "tan^-1": .inverseTrigonometry(atan),
            "+": .binary { $0 + $1 },
            "-": .binary { $0 - $1 },
            "X": .binary { $0 * $1 },
            "/": .binary { $0 / $1 },
            "y^x": .binary { pow($1, $0) },
            "EE": .binary { $0 * pow(10, $1) },
            "y√x": .binary { pow($0, 1/$1) },
            "x^y": .binary { pow($0, $1) },
            "logx": .binary { log($0) / log($1) },
            "=": .equals
    ]
    var result: Double? {
        return accumulator
    }
    var appendAccumulator = true

    func performOperation(_ symbol: String) {
        guard let operation = operations[symbol] else {
            return
        }
        switch operation {
        case .constant(let value):
            accumulator = value
            appendAccumulator = false
        case .unary(let function) where accumulator != nil:
            accumulator = function(accumulator ?? 0)
            appendAccumulator = false
        case .binary(let function) where accumulator != nil && pendingBinaryOperation == nil:
            flagForStack = false
            pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator ?? 0)
            appendAccumulator = true
        case .trigonometry(let function):
            accumulator = isRadian ? function(accumulator ?? 0) : function((accumulator ?? 0) * .pi/180)
        case .inverseTrigonometry(let function):
            accumulator = isRadian ? function(accumulator ?? 0) : function(accumulator ?? 0) * 180 / .pi
        case .equals where accumulator != nil && pendingBinaryOperation != nil:
            accumulator = pendingBinaryOperation?.perform(with: accumulator ?? 0)
            pendingBinaryOperation = nil
            appendAccumulator = true
            flagForStack = true
        case .rand(let function):
            accumulator = function()
        default:
            break
        }
    }
    func reset() {
        accumulator = nil
        pendingBinaryOperation = nil
    }
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
}
extension CalculatorService {
    private enum Operation {
        case rand(() -> Double)
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case trigonometry((Double) -> Double)
        case inverseTrigonometry((Double) -> Double)
        case equals
    }
}
extension CalculatorService {
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
}
extension Double {
    func factorial() -> Double {
     return (fmod(self, floor(self)) == 0) ? Darwin.round(exp(lgamma(self + 1))) : exp(lgamma(self + 1))
    }
}
