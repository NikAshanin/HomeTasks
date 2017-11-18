import Foundation

class CalculatorProcessor {

    // MARK: - Singleton

    static let sharedInstance = CalculatorProcessor()

    private init() {}

    // MARK: - Private properties

    private var accumulator: Double?
    private var variables = [String: Double]()
    private let formatter = NumberFormatter()
    private var operandsAndOperations: [String] = []
    private var redoOperandAndOperations: [String] = []
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var description = DescriptionHandler.sharedInstance

    // MARK: - Public properties

    public var resultIsPending: Bool {
        get {
            if pendingBinaryOperation != nil {
                return true
            }
            return false
        }
        set {
            if newValue == false {
                pendingBinaryOperation = nil
            }
        }
    }

    public var result: Double? {
        return accumulator
    }

    public var calculatorOperations: [String: Operation] {
        return operations
    }

    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> (Double))
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }

    private var operations: [String: Operation] = [
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

    // MARK: - Private

    private  func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if let accumulator = accumulator {
                self.accumulator = pendingBinaryOperation?.perform(with: accumulator)
            }
            pendingBinaryOperation = nil
        }
    }

    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }

    // MARK: - Public

    public func performOperation(_ symbol: String) {
        print("Perform operation: current operation is \(symbol)")
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value

            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator ?? 0)
                }
            case .binaryOperation(let function):
                if pendingBinaryOperation != nil {
                    performPendingBinaryOperation()
                }
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator ?? 0)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                operandsAndOperations.removeAll()
                redoOperandAndOperations.removeAll()
            }
        }
    }

    public func setOperand(_ operand: Double) {
        accumulator = operand

        if !resultIsPending {
            operandsAndOperations.removeAll()
            description.cleanDescription()
            operandsAndOperations.append(String(operand))
        } else {
            operandsAndOperations.append(String(operand))
        }

        redoOperandAndOperations.removeAll()

        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        let formattedNumber = formatter.string(from: operand as NSNumber)
        description.addToDescription(digit: formattedNumber)
    }

    public func setValueTo(variable named: String) {
        operandsAndOperations.append(named)
    }

    public func calculateResult() {
        pendingBinaryOperation = nil

        for oper in operandsAndOperations {
            switch oper {
            case _ where (Double(oper) != nil):
                if let digit = Double(oper) {
                    accumulator = digit

                    description.addToDescription(digit: oper)
                }
            default:
                performOperation(oper)
                description.addToDescription(symbol: oper)
            }
        }
        print("Calulate result: operand and operation is \(String(describing: operandsAndOperations))")
        print("Calulate result: current accumulator is \(String(describing: accumulator))")
        print("Calulate result: is pinding \(String(describing: resultIsPending))")
    }

    public func isListEmpty(_ list: UndoRedo) -> Bool {
        switch list {
        case .undo:
            return operandsAndOperations.isEmpty
        case .redo:
            return redoOperandAndOperations.isEmpty
        }
    }

    public func appendTo(_ list: UndoRedo, symbol: String) {
        list == .undo ? operandsAndOperations.append(symbol) : redoOperandAndOperations.append(symbol)
    }

    public func returnLastFrom(_ list: UndoRedo) -> String {
        switch list {
        case .undo:
            return operandsAndOperations.last ?? "0"
        case .redo:
            return redoOperandAndOperations.last ?? "0"
        }
    }

    public func removeLastFrom(_ list: UndoRedo) {
        switch list {
        case .undo:
            operandsAndOperations.removeLast()
        case .redo:
            redoOperandAndOperations.removeLast()
        }
    }

    public func removeAllFrom(_ list: UndoRedo) {
        switch list {
        case .undo:
            operandsAndOperations.removeAll()
        case .redo:
            redoOperandAndOperations.removeAll()
        }
    }
}

enum UndoRedo {
    case undo
    case redo
}
