import Foundation

final class Calculator {

    static var stackOfOperations: [String] = []
    static let errorResult = "Не определено"
    static var indexOfStack = 1
    static private let constantsDictionaty: [String: String] = [
        "π": String(Double.pi),
        "Rand": String(Double(arc4random())),
        "e": String(M_E)
    ]
    private static var isDegree = true
    static var number: String?
    static var oldFunc: String?
    static var canCalculate: Bool = false

    enum Functions {
        case unary((Double)->String)
        case binary((Double, Double)->String)
    }

    static func square2(value: Double) -> String {
        if value < 0 {
            return errorResult
        } else {
            return String(pow(value, (1/2)))
        }
    }
    static func divideOne(value: Double) -> String {
        if value == 0 {
            return errorResult
        } else {
            return String(1 / value)
        }
    }
    static func ySqrtX(valueY: Double, valueX: Double) -> String {
        if valueX < 0 {
            return errorResult
        } else {
            return String(pow(valueX, (1/valueY)))
        }
    }

    static let operationToFunction: [String: Functions] = [
        "√x": Functions.unary({ square2(value: $0) }),
        "∛x": Functions.unary({ String(pow($0, (1/3))) }),
        "x!": Functions.unary({ if ($0 - Double(Int($0))) == 0.0 {
            return String(factorial(value: $0))
        } else { return errorResult }}),
        "sin": Functions.unary({ String(sin(setDegrees(value: $0))) }),
        "cos": Functions.unary({ String(cos(setDegrees(value: $0))) }),
        "tan": Functions.unary({ String(tan(setDegrees(value: $0))) }),
        "asin": Functions.unary({ String(asin($0)) }),
        "acos": Functions.unary({ String(acos($0)) }),
        "atan": Functions.unary({ String(atan($0)) }),
        "sinh": Functions.unary({ String(sinh($0)) }),
        "cosh": Functions.unary({ String(cosh($0)) }),
        "tanh": Functions.unary({ String(tanh($0)) }),
        "asinh": Functions.unary({ String(asinh($0)) }),
        "acosh": Functions.unary({ String(acosh($0)) }),
        "atanh": Functions.unary({ String(atanh($0)) }),
        "1/x": Functions.unary({ divideOne(value: $0) }),
        "x²": Functions.unary({ String(pow($0, 2)) }),
        "x³": Functions.unary({ String(pow($0, 3)) }),
        "+/−": Functions.unary({ String(-$0) }),
        "log10": Functions.unary({ String(log10($0)) }),
        "ln": Functions.unary({ String(log($0)) }),
        "10 ̽": Functions.unary({ String(pow(10, $0)) }),
        "%": Functions.unary({ String($0 / 100) }),
        "e ̽": Functions.unary({ String(pow(M_E, $0)) }),
        "-": Functions.binary({ String($0 - $1) }),
        "×": Functions.binary({ String($0 * $1) }),
        "÷": Functions.binary({ String($0 / $1) }),
        "ʸ√x": Functions.binary({ String(ySqrtX(valueY: $0, valueX: $1)) }),
        "xʸ": Functions.binary({ String(pow($0, $1)) }),
        "+": Functions.binary({ String($0 + $1) }),
        "EE": Functions.binary({ String($0 * pow(10, $1)) })
    ]

    static func calculate(inputNumber: String?, operationValue: String?) -> String {
        if indexOfStack > 1 {
            let length = stackOfOperations.count
            let lastStep = stackOfOperations[length-indexOfStack+1]
            stackOfOperations = Array(stackOfOperations.prefix(length-indexOfStack))
            indexOfStack = 1
            if Double(lastStep) != nil {
                number = nil
                oldFunc = nil
            } else {
                oldFunc = lastStep
            }
        }
        if number == nil {
            number = inputNumber
        }
        if oldFunc == nil {
            oldFunc = operationValue
        } else {
            canCalculate = true
        }
        perform(inputNumber: inputNumber, operationValue: operationValue)
        canCalculate = false
        stackOfOperations.append(inputNumber ?? "")
        if oldFunc != nil {
            perform(inputNumber: nil, operationValue: nil)
        }
        guard let result = self.number else {
            return errorResult
        }
        stackOfOperations.append(result)
        return result
    }

    static func perform(inputNumber: String?, operationValue: String?) {
        guard let key = oldFunc,
            let operation: Functions = operationToFunction[key],
            let number = number,
            let n = Double(number) else {
                return
        }
        switch operation {
        case .unary(let function):
            stackOfOperations.append(oldFunc ?? "")
            self.number = String(function(n))
            oldFunc = nil
            canCalculate = false
        case .binary(let function):
            if canCalculate {
                stackOfOperations.append(oldFunc ?? "")
                guard let inputNumber = inputNumber,
                    let newNumber = Double(inputNumber) else {
                        return
                }
                self.number = String(function(n, newNumber))
                oldFunc = operationValue
            }
        }
    }

    static func result(value: String?) -> String {
        return calculate(inputNumber: value, operationValue: nil)
    }

    static func clearResult(clear: Bool) {
        if clear {
            number = nil
            oldFunc = nil
            stackOfOperations = []
            indexOfStack = 1
        }
    }

    static func constantClick(operand: String) -> String {
        if let constant = constantsDictionaty[operand] {
            let result = constant
            return result
        } else {
            return errorResult
        }
    }

    static func setDegree() {
        isDegree = true
    }

    static func setRadian() {
        isDegree = false
    }

    static func undo() -> String {
        let length = stackOfOperations.count
        if length-1 < indexOfStack {
            return stackOfOperations[0]
        }
        let value = stackOfOperations[length-indexOfStack]
        indexOfStack += 1
        return value
    }

    static func redo() -> String {
        let length = stackOfOperations.count
        if indexOfStack < 2 {
            return stackOfOperations[length-1]
        }
        let value = stackOfOperations[length-indexOfStack]
        indexOfStack -= 1
        return value
    }

    private static func setDegrees(value: Double) -> Double {
        if self.isDegree {
            return value
        } else {
            return value * .pi / 180
        }
    }

    private static func factorial(value: Double) -> Double {
        if value > 0 {
            return value*factorial(value: value-1.0)
        } else {
            return 1
        }
    }
}
