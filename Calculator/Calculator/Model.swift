import Foundation

final class Model {
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case trigonometric((Double, Double) -> Double)
        case reset
    }

    var firstOperand: Double?
    var secondOperand: Double?
    var angleRate: AngleMeasureUnit = .radians
    private let operations: [String: Operation] = [
        "x": Operation.binary({ $0 * $1 }),
        "÷": Operation.binary({ $0 / $1 }),
        "+": Operation.binary({ $0 + $1 }),
        "-": Operation.binary({ $0 - $1 }),
        "xʸ": Operation.binary({ pow($0, $1) }),
        "ʸ√x": Operation.binary({ pow($0, 1/$1) }),
        "EE": Operation.binary({ $0 * pow(10, $1) }),
        "yˣ": Operation.binary({ pow($1, $0) }),
        "logy": Operation.binary({ $1.logarithm(toTheBase: $0) }),
        "sin": Operation.trigonometric({ sin($0 * $1) }),
        "cos": Operation.trigonometric({ cos($0 * $1) }),
        "tan": Operation.trigonometric({ tan($0 * $1) }),
        "sin-¹": Operation.trigonometric({ asin($0) / $1 }),
        "cos-¹": Operation.trigonometric({ acos($0) / $1 }),
        "tan-¹": Operation.trigonometric({ atan($0) / $1 }),
        "2ˣ": Operation.unary({ pow(2, $0) }),
        "log₂": Operation.unary(log2),
        "sinh-¹": Operation.unary(asinh),
        "cosh-¹": Operation.unary(acosh),
        "tanh-¹": Operation.unary(atanh),
        "%": Operation.unary({ $0 / 100 }),
        "±": Operation.unary({ -$0 }),
        "x²": Operation.unary({ pow($0, 2) }),
        "x³": Operation.unary({ pow($0, 3) }),
        "eˣ": Operation.unary(exp),
        "10ˣ": Operation.unary({ pow(10, $0) }),
        "1/x": Operation.unary({ 1 / $0 }),
        "√x": Operation.unary({ pow($0, 1/2) }),
        "∛x": Operation.unary({ pow($0, 1/3) }),
        "ln": Operation.unary(log),
        "log₁₀": Operation.unary(log10),
        "x!": Operation.unary({ $0.factorial() }),
        "sinh": Operation.unary(sinh),
        "cosh": Operation.unary(cosh),
        "tanh": Operation.unary(tanh),
        "Rand": Operation.unary({ _ in drand48() }),
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "AC": Operation.reset
    ]

    func performOperation(_ operationName: String) -> Double {
        guard let operation = operations[operationName] else {
            return secondOperand ?? 0.0
        }
        switch (operation, firstOperand, secondOperand, angleRate) {
        case (.constant(let x), _, _, _):
            return x
        case (.unary(let f), let first?, _, _):
            return f(first)
        case (.binary(let f), let first?, let second?, _):
            return f(first, second)
        case (.trigonometric(let f), let first?, _, let angle):
            return angle == .degrees ? f(first, Double.pi / 180.0) : f(first, 1.0)
        default:
            firstOperand = nil
            secondOperand = nil
            return 0.0
        }
    }
}

fileprivate extension Double {
    func logarithm(toTheBase secondOperand: Double) -> (Double) {
        return log(secondOperand) / log(self)
    }

    func factorial() -> Double {
        guard self < Double(UInt64.max) else {
            return Double.infinity
        }
        guard let integerOperand = UInt64(exactly: self) else {
            return Double.nan
        }
        guard integerOperand != 0 else {
            return 1.0
        }
        var fact = 1.0
        for index in 1...UInt64(integerOperand) {
            if fact > Double.greatestFiniteMagnitude {
                return Double.infinity
            }
            fact *= Double(index)
        }
        return fact
    }
}

// MARK: - Angle rate
enum AngleMeasureUnit {
    case degrees
    case radians
}
