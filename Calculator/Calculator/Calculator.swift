import Foundation

private func factorial(op: Double) -> Double {
    if op >= 0 {
        return op == 0 ? 1 : op * factorial(op: op - 1)
    } else {
        return 0 / 0
    }
}

private func logN(op1: Double, op2: Double) -> Double {
   return log(op1)/log(op2)
}

private func random() -> Double {
    return drand48()
}

struct Calculator {
    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    enum Operation {
        case constant (Double)
        case unaryOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
    }
    private var operations: Dictionary <String,Operation> =
        [
            "2^x": Operation.unaryOperation ({pow(2, $0)}),
            "x^2": Operation.unaryOperation ({pow($0, 2)}),
            "x^3": Operation.unaryOperation ({pow($0, 3)}),
            "x^y": Operation.binaryOperation ({pow($0, $1)}),
            "e^x": Operation.unaryOperation ({pow(M_E, $0)}),
            "10^x": Operation.unaryOperation ({pow(10, $0)}),
            "1/x": Operation.unaryOperation ({1 / $0}),
            "√": Operation.unaryOperation (sqrt),
            "∛": Operation.unaryOperation  ({pow($0, 1/3)}),
            "y√": Operation.binaryOperation ({pow($0, 1/$1)}),
            "ln": Operation.unaryOperation (log),
            "log10": Operation.unaryOperation (log10),
            "x!": Operation.unaryOperation ({factorial(op: $0)}),
            "sin": Operation.unaryOperation (sin),
            "cos": Operation.unaryOperation (cos),
            "tan": Operation.unaryOperation (tan),
            "e": Operation.constant (M_E),
            "log2": Operation.unaryOperation (log2),
            "sinh": Operation.unaryOperation (sinh),
            "sin^-1": Operation.unaryOperation (asin),
            "cos^-1": Operation.unaryOperation (acos),
            "tan^-1": Operation.unaryOperation (atan),
            "π": Operation.constant (Double.pi),
            "logy": Operation.binaryOperation ({logN(op1: $0, op2: $1)}),
            "cosh": Operation.unaryOperation (cosh),
            "tanh": Operation.unaryOperation (tanh),
            "sinh^-1": Operation.unaryOperation (asinh),
            "cosh^-1": Operation.unaryOperation (acosh),
            "tanh^-1": Operation.unaryOperation (atanh),
            "Rand": Operation.unaryOperation({_ in random()}),
            "EE": Operation.binaryOperation ({$0 * pow(10, $1)}),
            "%": Operation.unaryOperation ({$0 / 100}),
            "±": Operation.unaryOperation ({-$0}),
            "×": Operation.binaryOperation ({$0 * $1}),
            "÷": Operation.binaryOperation ({$0 / $1}),
            "+": Operation.binaryOperation ({$0 + $1}),
            "-": Operation.binaryOperation ({$0 - $1}),
            "=": Operation.equals
    ]
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation (let function):
                guard accumulator != nil else { return }
                accumulator = function (accumulator!)
            case .binaryOperation (let function):
                guard accumulator != nil else { return }
                pendingBinaryOperation = PendingBinaryOperation (function: function, firstOperand: accumulator!)
                accumulator = nil
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    private mutating func  performPendingBinaryOperation() {
        guard pendingBinaryOperation != nil else { return }
        accumulator = pendingBinaryOperation?.perform(with: accumulator!)
        pendingBinaryOperation = nil
    }
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform (with secondOperand: Double) -> Double {
            return function (firstOperand, secondOperand)
        }
    }
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
    }
    var result: Double? {
        get {
            return accumulator
        }
    }
}
