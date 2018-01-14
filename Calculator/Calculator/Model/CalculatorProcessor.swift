import Foundation

final class CalculatorProcessor {

    // MARK: - Private properties

    private var accumulator: Double?
    private var variables = [String: Double]()
    private let formatter = NumberFormatterConfigurator()
    private var operandsAndOperations: [String] = []
    private var redoOperandAndOperations: [String] = []
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var description = DescriptionHandler()
    private let operations = Operations()

    // MARK: - Public properties

    var getDescription: String? {
        return description.getDescription
    }

    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
        set {
            if newValue == false {
                pendingBinaryOperation = nil
            }
        }
    }

    var result: Double? {
        return accumulator
    }

    // MARK: - Private

    private  func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if let accumulator = accumulator {
                self.accumulator = pendingBinaryOperation?.perform(with: accumulator)
            }
            pendingBinaryOperation = nil
        }
    }

    func handleClean() {
        resultIsPending = false

        description.cleanDescription()
        removeAllFrom(.undo)
        removeAllFrom(.redo)
    }

    // MARK: - Public

    func performOperation(_ symbol: String) {
        if let operation = operations.operations[symbol] {
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

    func setOperand(_ operand: Double) {
        accumulator = operand

        if !resultIsPending {
            operandsAndOperations.removeAll()
            description.cleanDescription()
            operandsAndOperations.append(String(operand))
        } else {
            operandsAndOperations.append(String(operand))
        }

        redoOperandAndOperations.removeAll()

        let formattedNumber = formatter.string(from: operand as NSNumber)
        description.addToDescription(digit: formattedNumber, resultIsPending: resultIsPending)
    }

    func setValueTo(variable named: String) {
        operandsAndOperations.append(named)
    }

    func calculateResult() {
        pendingBinaryOperation = nil

        for oper in operandsAndOperations {
            switch oper {
            case _ where (Double(oper) != nil):
                if let digit = Double(oper) {
                    accumulator = digit

                    description.addToDescription(digit: oper, resultIsPending: resultIsPending)
                }
            default:
                performOperation(oper)
                description.addToDescription(symbol: oper, resultIsPending: resultIsPending)
            }
        }
    }

    func isListEmpty(_ list: UndoRedo) -> Bool {
        switch list {
        case .undo:
            return operandsAndOperations.isEmpty
        case .redo:
            return redoOperandAndOperations.isEmpty
        }
    }

    func appendTo(_ list: UndoRedo, symbol: String) {
        if list == .undo {
            operandsAndOperations.append(symbol)
            removeLastFrom(.redo)
            description.addToDescription(symbol: symbol, resultIsPending: resultIsPending)
        } else {
            redoOperandAndOperations.append(symbol)
            removeLastFrom(.undo)
        }
    }

    func cleanDescription() {
        description.cleanDescription()
    }

    func returnLastFrom(_ list: UndoRedo) -> String {
        switch list {
        case .undo:
            return operandsAndOperations.last ?? "0"
        case .redo:
            return redoOperandAndOperations.last ?? "0"
        }
    }

    func removeLastFrom(_ list: UndoRedo) {
        switch list {
        case .undo:
            guard !operandsAndOperations.isEmpty else {
                return
            }
            operandsAndOperations.removeLast()
        case .redo:
            guard !redoOperandAndOperations.isEmpty else {
                return
            }
            redoOperandAndOperations.removeLast()
        }
    }

    func removeAllFrom(_ list: UndoRedo) {
        switch list {
        case .undo:
            operandsAndOperations.removeAll()
        case .redo:
            redoOperandAndOperations.removeAll()
        }
    }
}

enum UndoRedo: String {
    case undo = "Undo"
    case redo = "Redo"
}
