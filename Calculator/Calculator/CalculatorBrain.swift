import Foundation

final class CalculatorBrain {
     enum Operation {
        case constant (Double)
        case unaryOperation ((Double) -> Double)
        case geomOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
        case redo
        case undo
    }

    var operations =
        [
            "п": Operation.constant (Double.pi),
            "e": Operation.constant (M_E),
            "e^x": Operation.unaryOperation({ pow(M_E, $0) }),
            "sqrt": Operation.unaryOperation(sqrt),
            "3sqrt": Operation.unaryOperation({ pow($0, 1.0 / 3.0) }),
            "cos": Operation.geomOperation (cos),
            "cos^-1": Operation.geomOperation(acos),
            "sin": Operation.geomOperation (sin),
            "sin^-1": Operation.geomOperation(asin),
            "tan": Operation.geomOperation (tan),
            "tan^-1": Operation.geomOperation(atan),
            "sinh": Operation.geomOperation (sinh),
            "cosh": Operation.geomOperation (cosh),
            "cosh^-1": Operation.geomOperation(acosh),
            "tanh": Operation.geomOperation (tanh),
            "tanh^-1": Operation.geomOperation(atanh),
            "x!": Operation.unaryOperation(factorial),
            "*": Operation.binaryOperation ({ $0 * $1 }),
            "/": Operation.binaryOperation ({ $0 / $1 }),
            "+": Operation.binaryOperation ({ $0 + $1 }),
            "–": Operation.binaryOperation ({ $0 - $1 }),
            "x^2": Operation.unaryOperation({ pow($0, 2) }),
            "x^3": Operation.unaryOperation({ pow($0, 3) }),
            "log10": Operation.unaryOperation(log10),
            "ln": Operation.unaryOperation(log),
            "10^x": Operation.unaryOperation({ pow(10, $0) }),
            "1/x": Operation.unaryOperation({ 1 / $0 }),
            "=": Operation.equals,
            "<-": Operation.undo,
            "->": Operation.redo
    ]

    static func factorial(_ number: Double) -> Double {
        var fact = 1
        for i in 1...Int(number) {
            fact*=i
        }
        return Double(fact)
    }
}
