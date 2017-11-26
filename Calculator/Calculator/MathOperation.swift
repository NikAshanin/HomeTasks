import Foundation

func factorialFunc(_ someValue: Int) -> Int {
    var facto = 1
    if someValue < 2 {
        return facto
    }
    if someValue < 20 {
    for i in 2...someValue {
        facto *= i
        }
    }
    return facto
}

func degreesToRadians(_ number: Double) -> Double {
    return number * .pi / 180
}

struct CalculatorBrain {
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var accumulator: Double? = 0.0
    private var resultSum: Double?
    var inDeg = false
    var memoryArray: [(Double, String)] = [(0.0, "")]
    var memoryArrayLength = 0
    var buttonPressed = false
    var result: Double? {
            return accumulator
    }
    private var operations =
        [
            "π": Operation.constant (Double.pi),
            "e": Operation.constant (M_E),
            "ex": Operation.unaryOperation ({ pow(M_E, $0) }),
            "√x": Operation.unaryOperation (sqrt),
            "∛x": Operation.unaryOperation ({ pow($0, 1.0 / 3.0) }),
            "ʸ√x": Operation.binaryOperation({ pow($0, 1.0 / $1) }),
            "cos": Operation.geomOperation (cos),
            "cos⁻¹": Operation.geomOperation(acos),
            "sin": Operation.geomOperation (sin),
            "sin⁻¹": Operation.geomOperation(asin),
            "tan": Operation.geomOperation (tan),
            "tan⁻¹": Operation.geomOperation(atan),
            "sinh": Operation.geomOperation (sinh),
            "cosh": Operation.geomOperation (cosh),
            "cosh⁻¹": Operation.geomOperation(acosh),
            "tanh": Operation.geomOperation (tanh),
            "tanh⁻¹": Operation.geomOperation(atanh),
            "±": Operation.changeOperation ({ -$0 }),
            "Rand": Operation.constant (Double(arc4random())),
            "x!": Operation.factorial(factorialFunc),
            "×": Operation.binaryOperation ({ $0 * $1 }),
            "÷": Operation.binaryOperation ({ $0 / $1 }),
            "+": Operation.binaryOperation ({ $0 + $1 }),
            "–": Operation.binaryOperation ({ $0 - $1 }),
            "2ˣ": Operation.unaryOperation({ pow(2, $0) }),
            "x²": Operation.unaryOperation ({ $0 * $0 }),
            "xʸ": Operation.binaryOperation({ pow($0, $1) }),
            "yˣ": Operation.binaryOperation({ pow($0, $1) }),
            "x³": Operation.unaryOperation ({ $0 * $0 * $0 }),
            "%": Operation.unaryOperation ({ $0 / 100 }),
            "log₁₀": Operation.unaryOperation (log10),
            "log₂": Operation.unaryOperation(log2),
            "ln": Operation.unaryOperation (log2),
            "10ˣ": Operation.unaryOperation({ pow(10, $0) }),
            "1/x": Operation.unaryOperation({ 1.0 / $0 }),
            "EE": Operation.binaryOperation({ $0 * pow(10, $1) }),
            "AC": Operation.clearAc,
            "C": Operation.clearAc,
            "=": Operation.equals
            ]
    private enum Operation {
        case constant (Double)
        case unaryOperation ((Double) -> Double)
        case geomOperation ((Double) -> Double)
        case changeOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
        case factorial ((Int) -> Int)
        case clearAc
    }
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                buttonPressed = false; resultSum = value; accumulator = resultSum
            case .unaryOperation (let function):
                if buttonPressed == false {
                    accumulator = function (accumulator ?? 0)
                    performPendingBinaryOperation()
                    memoryMagic(symbol: "")
                }
            case .geomOperation(let function):
                if buttonPressed == false {
                    if inDeg {
                        accumulator = degreesToRadians(accumulator ?? 0)
                    }
                        accumulator = function (accumulator ?? 0)
                        performPendingBinaryOperation()
                }
            case .changeOperation(let function):
                buttonPressed = false; accumulator = function (accumulator ?? 0)
            case .binaryOperation (let function):
                if resultSum != nil && !buttonPressed {
                    resultSum = pendingBinaryOperation?.perform(with: accumulator ?? 0)
                    pendingBinaryOperation = PendingBinaryOperation (function: function, firstOperand: resultSum ?? 0)
                    accumulator = resultSum ?? 0
                    memoryMagic(symbol: symbol)
                    buttonPressed = true
                }
                if !buttonPressed || pendingBinaryOperation == nil {
                    pendingBinaryOperation = PendingBinaryOperation (function: function, firstOperand: accumulator ?? 0)
                    resultSum = accumulator; buttonPressed = false
                }
                if memoryArray.count == 1 {
                    memoryMagic(symbol: symbol)
                }
            case .equals:
               if !buttonPressed {
                    performPendingBinaryOperation()
                } else {
                    accumulator = memoryArray[memoryArrayLength-1].0
               }
               resultSum = nil
               memoryMagic(symbol: symbol)
            case .factorial(let function):
                    accumulator = Double(function(Int(accumulator ?? 0)))
            case .clearAc:
                clear()
            }
        }
    }
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double, firstOperand: Double
        func perform (with secondOperand: Double) -> Double {
            return function (firstOperand, secondOperand)
        }
    }
    private mutating func  performPendingBinaryOperation() {
        if pendingBinaryOperation != nil {
            if let number = accumulator {
                accumulator = pendingBinaryOperation?.perform(with: number)
            }
            pendingBinaryOperation = nil
            buttonPressed = false
        }
    }
    mutating func doUndoFunction() {
        print(memoryArray)
        print(buttonPressed)
        if memoryArrayLength >= 1 {
            resultSum = nil
            if buttonPressed {
                memoryArrayLength -= 1
                pendingBinaryOperation = nil
                resultSum = accumulator
                buttonPressed = false
                if memoryArray[memoryArrayLength + 1].1 == "" {
                    accumulator = memoryArray[memoryArrayLength].0
                    buttonPressed = true
                    }
            } else {
                accumulator = memoryArray[memoryArrayLength].0
                if memoryArray[memoryArrayLength].1 == "=" {
                    accumulator = memoryArray[memoryArrayLength - 1].0
                    memoryArrayLength -= 1
                }
                performOperation(memoryArray[memoryArrayLength].1)
                buttonPressed = true
                }
            } else {
            accumulator = 0
            buttonPressed = true
            }
        }

     mutating func doRedoFunction() {
        if memoryArrayLength < memoryArray.count - 1 {
            resultSum = nil
            if buttonPressed {
                accumulator = memoryArray[memoryArrayLength + 1].0
                buttonPressed = false
                pendingBinaryOperation = nil
                resultSum = accumulator
                print("Redo(Pressed)  \(memoryArrayLength)")
            } else {
                performOperation(memoryArray[memoryArrayLength].1)
                memoryArrayLength += 1
                buttonPressed = true
                print("Redo(NotPressed) \(memoryArrayLength)")
            }
        }
    }
    mutating func clear() {
        accumulator = 0
        resultSum = nil
        memoryArray = [(0, "")]
        buttonPressed = false
        memoryArrayLength = 0
    }
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
    }
    mutating func memoryMagic (symbol: String) {
        memoryArray.append((accumulator ?? 0, symbol))
        memoryArrayLength = memoryArray.count - 1
    }

    mutating func checkPressedButton() {
        buttonPressed = false
    }
}
