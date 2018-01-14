import Foundation

private struct BinaryOperation {
    var function: (Double, Double) -> Double
    var firstOperand: Double

    func perform(with secondOperand: Double) -> Double {
        return function(firstOperand, secondOperand)
    }
}

final class Calculation {

    private var operand: Double = 0
    private var undoParameters: [CalculationParameter] = []
    var isRadian = false
    var result: Double {
        return operand
    }

    private enum CalculationParameter {
        case operand(Double)
        case operation(String)
    }

    private enum Operation {
        case rand(() -> Double)
        case number(Double)
        case unary((Double) -> Double)
        case trigonometry((Double) -> Double)
        case inverseTrigonometry((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equal
    }

    private var operationsDictionary = [
        "Rand": Operation.rand { Double(arc4random()) / Double(UInt32.max) },
        "e": Operation.number(M_E),
        "π": Operation.number(.pi),
        "√x": Operation.unary { sqrt($0) },
        "∛x": Operation.unary { pow($0, 1/3) },
        "%": Operation.unary { $0 / 100 },
        "+/-": Operation.unary { -$0 },
        "x²": Operation.unary { pow($0, 2) },
        "x³": Operation.unary { pow($0, 3) },
        "eˣ": Operation.unary { pow(M_E, $0) },
        "10ˣ": Operation.unary { pow(10, $0) },
        "2ˣ": Operation.unary { pow(2, $0) },
        "x!": Operation.unary { $0.factorial() },
        "sinh⁻¹": Operation.unary(asinh),
        "cosh⁻¹": Operation.unary(acosh),
        "tanh⁻¹": Operation.unary(atanh),
        "ln": Operation.unary(log),
        "log₁₀": Operation.unary(log10),
        "log₂": Operation.unary(log2),
        "1/x": Operation.unary { 1 / $0 },
        "sin": Operation.trigonometry(sin),
        "cos": Operation.trigonometry(cos),
        "tan": Operation.trigonometry(tan),
        "sinh": Operation.trigonometry(sinh),
        "cosh": Operation.trigonometry(cosh),
        "tanh": Operation.trigonometry(tanh),
        "sin⁻¹": Operation.inverseTrigonometry(asin),
        "cos⁻¹": Operation.inverseTrigonometry(acos),
        "tan⁻¹": Operation.inverseTrigonometry(atan),
        "+": Operation.binary { $0 + $1 },
        "-": Operation.binary { $0 - $1 },
        "×": Operation.binary { $0 * $1 },
        "÷": Operation.binary { $0 / $1 },
        "yˣ": Operation.binary { pow($1, $0) },
        "EE": Operation.binary { $0 * pow(10, $1) },
        "ʸ√x": Operation.binary { pow($0, 1/$1) },
        "xʸ": Operation.binary { pow($0, $1) },
        "logᵧ": Operation.binary { log($0) / log($1) },
        "=": Operation.equal
    ]

    private var binaryOperation: BinaryOperation?

    func performOperation(_ mathSign: String) {
        guard let operation = operationsDictionary[mathSign] else {
            return

        }
        calculationParameters.append(CalculationParameter.operation(mathSign))
        switch operation {
        case .rand(let function):
            operand = function()
        case .number(let value):
            operand = value
        case.unary(let function):
            operand = function(operand)
        case .trigonometry(let function):
            operand = isRadian ? function(operand) : function(operand * .pi/180)
        case .inverseTrigonometry(let function):
            operand = isRadian ? function(operand) : function(operand) * 180 / .pi
        case .binary(let function):
            executeBinaryOperation()
            binaryOperation = BinaryOperation(function: function,
                                              firstOperand: operand)
        case .equal:
            executeBinaryOperation()
        }
    }

    private var calculationParameters: [CalculationParameter] = []
    private var calculationSequence: [CalculationParameter] {
        get {
            return calculationParameters
        }
        set {
            clear()
            for obj in newValue {
                switch obj {
                case .operand(let operand):
                    setOperand(operand)
                case .operation(let mathSign):
                    performOperation(mathSign)
                }
            }
        }
    }

    private func executeBinaryOperation() {
        guard let binaryOperation = binaryOperation else {
            return
        }
        operand = binaryOperation.perform(with: operand)
        self.binaryOperation = nil
    }

    func clearAll() {
        clear()
        undoParameters.removeAll(keepingCapacity: false)
    }

    private func clear() {
        operand = 0
        binaryOperation = nil
        calculationParameters.removeAll(keepingCapacity: false)
    }

    func setOperand(_ operand: Double) {
        self.operand = operand
        calculationParameters.append(CalculationParameter.operand(operand))
    }

    func undoCalculationParameter() {
        guard !calculationParameters.isEmpty else {
            return

        }
        undoParameters.append(calculationParameters.removeLast())
        calculationSequence = calculationParameters
    }

    func redoCalculationParameter() {
        if !undoParameters.isEmpty, let last = undoParameters.last {
            calculationParameters.append(last)
            calculationSequence = calculationParameters
            undoParameters = Array(undoParameters.dropLast())
        }
    }
}

private extension Double {
    /// Factorial with gamma function for all complex numbers except the non-positive integers
    func factorial() -> Double {
        var factorial: Double = 0

        if (fmod(self, floor(self)) == 0) {
            factorial = Darwin.round(exp(lgamma(self + 1)))
        } else {
            factorial = exp(lgamma(self + 1))
            print(factorial)
        }
        return factorial
    }
}
