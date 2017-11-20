import Foundation

func converDoubleToString(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 9
    var stringFromDouble = formatter.string(from: NSNumber(value: value))!
        if stringFromDouble.first == "."{
            stringFromDouble = "0"+stringFromDouble
        }
    return stringFromDouble
}

class Model {

    var stack = Stack()
    var degreesMode = true
    var reestablishingModel = false
    private var pendingBinaryOperation: PendingBinaryOperation? {
        didSet {
            pendingFunction = resultIsPending ? pendingBinaryOperation!.fun : nil
        }
    }
    private var accumulator: Double?

    private var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }

    var result: Double? {
        return accumulator
    }

    var pendingFunction: String?

    private var operators: [String: OperationType] = [
        //constants
        "π": OperationType.constant(Double.pi),
        "e": OperationType.constant(M_E),
        //unary
        "²√x": OperationType.unaryOperation(sqrt),
        "∛x": OperationType.unaryOperation({ pow($0, 1/3) }),
        "x²": OperationType.unaryOperation({ $0*$0 }),
        "x³": OperationType.unaryOperation({ pow($0, 3) }),
        "x⁻¹": OperationType.unaryOperation({ 1/$0 }),
        "10ˣ": OperationType.unaryOperation({ pow(10, $0) }),
        "2ˣ": OperationType.unaryOperation({ pow(2, $0) }),
        "eˣ": OperationType.unaryOperation({ pow(M_E, $0) }),
        "ln": OperationType.unaryOperation({ log($0)/log(M_E) }),
        "log₁₀": OperationType.unaryOperation(log10),
        "log₂": OperationType.unaryOperation(log2),
        "x!": OperationType.unaryOperation(factorial),
        "cos": OperationType.trigonometryOperation(cos),
        "sin": OperationType.trigonometryOperation(sin),
        "tan": OperationType.trigonometryOperation(tan),
        "sinh": OperationType.trigonometryOperation(sinh),
        "cosh": OperationType.trigonometryOperation(cosh),
        "tanh": OperationType.trigonometryOperation(tanh),
        "cos⁻¹": OperationType.trigonometryOperation(acos),
        "sin⁻¹": OperationType.trigonometryOperation(asin),
        "tan⁻¹": OperationType.trigonometryOperation(atan),
        "sinh⁻¹": OperationType.trigonometryOperation(asinh),
        "cosh⁻¹": OperationType.trigonometryOperation(acosh),
        "tanh⁻¹": OperationType.trigonometryOperation(atanh),
        "%": OperationType.unaryOperation({ $0/100 }),
        "±": OperationType.unaryOperation({ -$0 }),
        //binary
        "logᵧ": OperationType.binaryOperation({ log($1)/log($0) }),
        "+": OperationType.binaryOperation({ $0+$1 }),
        "-": OperationType.binaryOperation({ $0-$1 }),
        "×": OperationType.binaryOperation(*),
        "÷": OperationType.binaryOperation(/),
        "ʸ√x": OperationType.binaryOperation({ pow($0, 1.0/$1) }),
        "xʸ": OperationType.binaryOperation({ pow($1, $0) }),
        "yˣ": OperationType.binaryOperation({ pow($0, $1) }),
        "EE": OperationType.binaryOperation({ $0*pow(10, $1) }),
        //random and equals
        "Rand": OperationType.random({ Double(arc4random())/Double(UInt32.max) }),
        "=": OperationType.equals
    ]

    enum OperationType {
        case constant(Double)
        case unaryOperation((Double)->Double)
        case trigonometryOperation((Double)->Double)
        case binaryOperation((Double, Double)->Double)
        case equals
        case random(()->Double)
    }

    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let fun: String
        func perform (with secondOperand: Double) -> Double {
            return (function(firstOperand, secondOperand))
        }
    }

    func doOperation (_ symbol: String) {
        guard let operation = operators[symbol] else {
            return
        }
        var pendingOperationWasPerformed = false
        switch (operation, accumulator) {
        case (.constant(let value), _):
            accumulator = value
        case (.trigonometryOperation(let function), .some):
            accumulator = degreesMode ? radiansToDegree(accumulator!) : accumulator!
            accumulator = function(accumulator!)
        case (.unaryOperation(let function), .some):
            accumulator = (function(accumulator!))
        case (.binaryOperation(let function), .some):
            performPendingOperation()
            pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, fun: symbol)
            if !reestablishingModel {
                stack.push(value: accumulator!, fun: symbol)
            }
            accumulator = nil
        case (.equals, .some):
            if pendingBinaryOperation != nil {
                accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                pendingBinaryOperation=nil
                pendingOperationWasPerformed = true
            }
        case (.random(let function), _):
            accumulator = function()
        default:
            break
        }

        if let acc = accumulator, symbol != "=" || pendingOperationWasPerformed, !reestablishingModel {
            stack.push(value: acc, fun: symbol)
        }
    }

    func setOperand (_ operand: Double) {
        accumulator = operand
        if let acc = accumulator, !reestablishingModel {
            stack.push(value: acc, fun: nil)
        }
    }

    func resetPendingOperation() {
        pendingBinaryOperation = nil
    }

    func undo() {
        if let (value, function) = stack.pop() {
            reestablishModel(value, function)
        }
    }

    func redo() {
        if let (value, function) = stack.goForward() {
            reestablishModel(value, function)
        }
    }

    private func reestablishModel(_ value: Double, _ function: String?) {
        reestablishingModel = true
        setOperand(value)
        if let symbol = function {
            doOperation(symbol)
        } else {
            pendingBinaryOperation = nil
        }
        setOperand(value)
        reestablishingModel = false
    }

    private func performPendingOperation() {
        if let pendingBinaryOperation = pendingBinaryOperation {
            accumulator = pendingBinaryOperation.perform(with: accumulator!)
        }
    }

    private func radiansToDegree(_ radians: Double) -> Double {
        return radians * Double.pi / 180
    }

    private class func factorial (value: Double) -> Double {
        if value.remainder(dividingBy: 1) != 0.0 {
            return Double.nan
        }
        var factorial = 1
        for nextMultiplier in 1...Int(value) {
            factorial *= nextMultiplier
        }
        return Double(factorial)
    }
}
