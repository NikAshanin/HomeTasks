import Foundation

final class Operations {
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> (Double))
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }

    var operations: [String: Operation] = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),

        "2√x": Operation.unaryOperation(sqrt),
        "∛x": Operation.unaryOperation(cbrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "cos-1": Operation.unaryOperation(acos),
        "sin-1": Operation.unaryOperation(asin),
        "tan-1": Operation.unaryOperation(atan),
        "cosh": Operation.unaryOperation(cosh),
        "sinh": Operation.unaryOperation(sinh),
        "tanh": Operation.unaryOperation(tanh),
        "cosh-1": Operation.unaryOperation(acosh),
        "sinh-1": Operation.unaryOperation(asinh),
        "tanh-1": Operation.unaryOperation(atanh),
        "log2": Operation.unaryOperation(log2),
        "log10": Operation.unaryOperation(log10),
        "ln": Operation.unaryOperation(log),
        "x²": Operation.unaryOperation({ pow($0, 2) }),
        "x³": Operation.unaryOperation({ pow($0, 3) }),
        "±": Operation.unaryOperation({ -$0 }),
        "e^x": Operation.unaryOperation({ pow(M_E, $0) }),
        "10^x": Operation.unaryOperation({ pow(10, $0) }),
        "2^x": Operation.unaryOperation({ pow(2, $0) }),
        "1/x": Operation.unaryOperation({ 1 / $0 }),
        "x!": Operation.unaryOperation({ $0.factorial }),
        "EE": Operation.unaryOperation({ pow(10, $0) }),

        "%": Operation.binaryOperation({ $0.truncatingRemainder(dividingBy: $1) }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "x^y": Operation.binaryOperation({ pow($1, $0) }),
        "y√x": Operation.binaryOperation({ pow($0, 1.0 / $1) }),
        "logy": Operation.binaryOperation({ $0.logY($1) }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),

        "=": Operation.equals,
        "C": Operation.clear
    ]
}
