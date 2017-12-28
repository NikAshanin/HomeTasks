import Foundation

extension Double {
    func factorialFunc() -> Double {
        return self == 0.0 ? 1 : self * (self - 1).factorialFunc()
    }
}

extension Double {
    func degreesToRadians() -> Double {
        return self * .pi / 180
    }
}

final class CalculatorBrain {
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var accumulator: Double?
    private var resultSum: Double?
    var haveError = false
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
            "ex": Operation.unaryOperation({ pow(M_E, $0) }, { $0.isNormal ? true : nil }),
            "√x": Operation.unaryOperation(sqrt, { $0 < 0 ? true : nil }),
            "∛x": Operation.unaryOperation({ pow($0, 1.0 / 3.0) }, { $0.isNormal ? true : nil }),
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
            "x!": Operation.unaryOperation({ $0.factorialFunc() }, { $0 < 0 || $0 > 20 ? true : nil }),
            "×": Operation.binaryOperation ({ $0 * $1 }),
            "÷": Operation.binaryOperation ({ $0 / $1 }),
            "+": Operation.binaryOperation ({ $0 + $1 }),
            "–": Operation.binaryOperation ({ $0 - $1 }),
            "2ˣ": Operation.unaryOperation({ pow(2, $0) }, { $0.isNormal ? true : nil }),
            "х²": Operation.unaryOperation({ pow($0, 2) }, { $0.isNormal ? true : nil }),
            "x³": Operation.unaryOperation({ pow($0, 3) }, { $0.isNormal ? true : nil }),
            "xʸ": Operation.binaryOperation({ pow($0, $1) }),
            "yˣ": Operation.binaryOperation({ pow($0, $1) }),
            "%": Operation.unaryOperation({ $0 / 100 }, { $0.isNormal ? true : nil }),
            "log₁₀": Operation.unaryOperation(log10, { $0 <= 0 ? true : nil }),
            "log₂": Operation.unaryOperation(log2, { $0 <= 0 ? true : nil }),
            "ln": Operation.unaryOperation(log, { $0 <= 0 ? true : nil }),
            "10ˣ": Operation.unaryOperation({ pow(10, $0) }, { $0.isNormal ? true : nil }),
            "1/x": Operation.unaryOperation({ 1 / $0 }, { $0 == 0 ? true : nil }),
            "EE": Operation.binaryOperation({ $0 * pow(10, $1) }),
            "AC": Operation.clearAc,
            "C": Operation.clearAc,
            "=": Operation.equals
            ]

    private enum Operation {
        case constant (Double)
        case unaryOperation ((Double) -> Double, (Double) -> Bool?)
        case geomOperation ((Double) -> Double)
        case changeOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
        case clearAc
    }

     func performOperation(_ symbol: String) {
        guard let operation = operations[symbol] else {
            return
        }
            switch operation {
            case .constant(let value):
                buttonPressed = false; resultSum = value; accumulator = resultSum
            case .unaryOperation (let function, let error):
                let invalidValue = error(accumulator ?? 0)
                if buttonPressed == false && invalidValue == nil {
                    accumulator = function (accumulator ?? 0)
                    performPendingBinaryOperation()
                    appendToMemory(symbol: "")
                } else {
                    haveError = true
                }
            case .geomOperation(let function):
                if buttonPressed == false {
                    if inDeg {
                        accumulator = accumulator?.degreesToRadians()
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
                    appendToMemory(symbol: symbol)
                    buttonPressed = true
                }
                if !buttonPressed || pendingBinaryOperation == nil {
                    pendingBinaryOperation = PendingBinaryOperation (function: function, firstOperand: accumulator ?? 0)
                    resultSum = accumulator; buttonPressed = false
                }
                if memoryArray.count == 1 {
                    appendToMemory(symbol: symbol)
                }
            case .equals:
               if !buttonPressed {
                    performPendingBinaryOperation()
                } else {
                    accumulator = memoryArray[memoryArrayLength-1].0
               }
               resultSum = nil
               appendToMemory(symbol: symbol)
            case .clearAc:
                clear()
        }
    }
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform (with secondOperand: Double) -> Double {
            return function (firstOperand, secondOperand)
        }
    }
    private  func  performPendingBinaryOperation() {
        if pendingBinaryOperation != nil {
            if let number = accumulator {
                accumulator = pendingBinaryOperation?.perform(with: number)
            }
            pendingBinaryOperation = nil
            buttonPressed = false
        }
    }

    func doUndoFunction() {
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

    func doRedoFunction() {
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

    private func clear() {
        accumulator = 0
        resultSum = nil
        memoryArray = [(0, "")]
        buttonPressed = false
        haveError = false
        memoryArrayLength = 0
    }

    func setOperand (_ operand: Double) {
        accumulator = operand
    }

    private func appendToMemory (symbol: String) {
        memoryArray.append((accumulator ?? 0, symbol))
        memoryArrayLength = memoryArray.count - 1
    }

    func checkPressedButton() {
        buttonPressed = false
    }
}
