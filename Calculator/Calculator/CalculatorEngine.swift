import Foundation

func factorial(_ number: Double) -> Double {
    return number == 0 ? 1 : number * factorial(number-1)
}

func radiansToDegrees(_ number: Double) -> Double {
    return number * .pi / 180
}

struct CalculatorEngine {
    // MARK: properties
    private var accumulator: Double?
    private var isPending: Bool = false
    private var error: String?
    private var inDegrees = true
    private var memory: [(operand: Double?, operation: String?)] = []
    private var undoIndex: Int?
    private var haveNotElementsForUndo = false
    var pendingBinaryOperation: PendingBinaryOperation?
    var operationIsSelected = false
    var result: (Double?, String?) {
        return (accumulator, error)
    }
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }

    //Enum of operations
    private enum Operation {
        case constant(Double)
        case nullaryOperation(() -> Double)
        case unaryOperation((Double) -> Double, ((Double) -> String?)?)
        case geometricOperation((Double) -> Double, ((Double) -> String?)?)
        case binaryOperation((Double, Double) -> Double, ((Double, Double) -> String?)?)
        case equals
    }

    private var operations: [String: Operation] =
        [
            "π": Operation.constant(Double.pi),
            "e": Operation.constant(M_E),
            "Rand": Operation.nullaryOperation({ Double(arc4random()) / Double(UInt32.max) }),
            "√x": Operation.unaryOperation(sqrt, { $0 < 0 ? "Ошибка" : nil }),
            "∛x": Operation.unaryOperation({ pow($0, 1.0 / 3.0) }, nil),
            "cos": Operation.geometricOperation(cos, nil),
            "cosh": Operation.geometricOperation(cosh, nil),
            "cos⁻¹": Operation.geometricOperation(acos, nil),
            "cosh⁻¹": Operation.geometricOperation(acosh, nil),
            "sin": Operation.geometricOperation(sin, nil),
            "sinh": Operation.geometricOperation(sinh, nil),
            "sin⁻¹": Operation.geometricOperation(asin, nil),
            "sinh⁻¹": Operation.geometricOperation(asinh, nil),
            "tan": Operation.geometricOperation(tan, nil),
            "tanh": Operation.geometricOperation(tanh, nil),
            "tan⁻¹": Operation.geometricOperation(atan, nil),
            "tanh⁻¹": Operation.geometricOperation(atanh, nil),
            "±": Operation.unaryOperation({ -$0 }, nil),
            "%": Operation.unaryOperation({ $0 / 100 }, nil),
            "x!": Operation.unaryOperation(factorial, { $0 < 0 ? "Ошибка" : nil }),
            "х²": Operation.unaryOperation({ pow($0, 2) }, nil),
            "x³": Operation.unaryOperation({ pow($0, 3) }, nil),
            "2ˣ": Operation.unaryOperation({ pow(2, $0) }, nil),
            "1/x": Operation.unaryOperation({ 1 / $0 }, { $0 == 0 ? "Ошибка" : nil }),
            "ln": Operation.unaryOperation(log, { $0 <= 0 ? "Ошибка" : nil }),
            "log₂": Operation.unaryOperation(log2, { $0 <= 0 ? "Ошибка" : nil }),
            "log₁₀": Operation.unaryOperation(log10, { $0 <= 0 ? "Ошибка" : nil }),
            "10ˣ": Operation.unaryOperation({ pow(10, $0) }, nil),
            "eˣ": Operation.unaryOperation({ pow(M_E, $0) }, nil),
            "ʸ√x": Operation.binaryOperation({ pow($0, 1 / $1) }, nil),
            "logᵧ": Operation.binaryOperation({ log($0) / log($1) }, { $0 <= 0 || $1 <= 0 ? "Ошибка" : nil }),
            "xʸ": Operation.binaryOperation({ pow($0, $1) }, nil),
            "yˣ": Operation.binaryOperation({ pow($1, $0) }, nil),
            "EE": Operation.binaryOperation({ $0 * pow(10, $1) }, nil),
            "×": Operation.binaryOperation({ $0 * $1 }, nil),
            "÷": Operation.binaryOperation({ $0 / $1 }, { $1 == 0 ? "Ошибка" : nil }),
            "+": Operation.binaryOperation({ $0 + $1 }, nil),
            "−": Operation.binaryOperation({ $0 - $1 }, nil),
            "=": Operation.equals
    ]

    //PendingBinaryOperation структура отложенной операции
    struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let validator: ((Double, Double) -> String?)?

        //Функция perform выполениния бинарной операции
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }

        //Функция validate проверяет корректность вычислений
        func validate(with secondOperand: Double) -> String? {
            guard let validator = validator else {
                return nil
            }
            return validator(firstOperand, secondOperand)
        }
    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        memory.append((operand: accumulator, operation: nil))
        print("Set operand: \(memory)")
    }

    mutating func performPendingBinaryOperation() {
        guard let number = accumulator else {
            return
        }
        if pendingBinaryOperation != nil {
            error = pendingBinaryOperation?.validate(with: number)
            accumulator = pendingBinaryOperation?.perform(with: number)
            pendingBinaryOperation = nil
        }
    }

    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol], var number = accumulator {
            switch operation {
            case .constant(let value):
                accumulator = value
                memory.append((operand: accumulator, operation: nil))
            case .nullaryOperation(let function):
                accumulator = function()
                memory.append((operand: accumulator, operation: nil))
            case .unaryOperation(let function, let validator):
                error = validator?(number)
                accumulator = function(number)
                memory[memory.count - 1].operation = symbol
                memory.append((operand: accumulator, nil))
            case .geometricOperation(let function, let validator):
                error = validator?(number)
                if inDegrees {
                    number = radiansToDegrees(number)
                }
                accumulator = function(number)
                memory[memory.count - 1].operation = symbol
                memory.append((operand: accumulator, nil))
            case .binaryOperation(let function, let validator):
                performPendingBinaryOperation()
                if !operationIsSelected && accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function,
                                                                    firstOperand: number,
                                                                    validator: validator)
                    memory[memory.count - 1].operation = symbol
                    if undoIndex != nil { memory.removeAll() }
                }
            case .equals:
                performPendingBinaryOperation()
                memory[memory.count - 1].operation = symbol
                memory.append((operand: accumulator, nil))
            }
        }
    }

    mutating func changeMeasure(_ buttomIsRad: Bool) {
        inDegrees = buttomIsRad
    }

    mutating func clear() {
        accumulator = 0
        pendingBinaryOperation = nil
        memory.removeAll()
        undoIndex = nil
        haveNotElementsForUndo = false
        operationIsSelected = false
    }

    mutating func undo() -> (Double?, String?) {
        if !memory.isEmpty && !haveNotElementsForUndo {
            if undoIndex == nil {
                undoIndex = 0
                return memory[memory.count - 1]
            } else {
                guard var index = undoIndex else {
                    return (nil, nil)
                }
                if memory.count - index - 1 < 0 {
                    return (nil, nil)
                } else if memory.count - index - 1 == 0 {
                    haveNotElementsForUndo = true
                    return memory[0]
                } else {
                    index += 1
                    undoIndex = index
                    return memory[memory.count - index - 1]
                }
            }
        } else {
            return (nil, nil)
        }
    }

    mutating func redo() -> (Double?, String?) {
        if !memory.isEmpty {
            if undoIndex == nil {
                return (nil, nil)
            } else {
                guard var index = undoIndex else {
                    return (nil, nil)
                }
                if undoIndex == 0 {
                    undoIndex = nil
                    haveNotElementsForUndo = false
                    return (nil, nil)
                } else {
                    index -= 1
                    undoIndex = index
                    return memory[memory.count - index - 1]
                }
            }
        }
        return (nil, nil)
    }
}

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 15
    formatter.notANumberSymbol = "Ошибка"
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
} ()
