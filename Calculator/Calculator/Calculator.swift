import Foundation

final class Calculator {
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var history = Stack()
    private var currentResult: Double = 0
    var result: Double {
        return currentResult
    }
    private let calcBrain = CalculatorBrain()
    private var radianMode = false
    private var recoveringFromHistory = false
    private var pendingOperationWasPerformed = false

    func performOperationByName(name: String) {
        guard let operation = calcBrain.operations[name] else {
            return
        }
        switch operation {
        case .constant(let value):
            currentResult = value
        case .unaryOperation (let function):
            currentResult = function(currentResult)
        case .geomOperation(let function):
            currentResult = function(currentResult)
            if radianMode {
                currentResult = currentResult * 180 / .pi
            }
        case .binaryOperation (let function):
            performPendingBinaryOperation()
            pendingBinaryOperation = PendingBinaryOperation(function: function, firstValue: currentResult, oper: name)
            saveResult(value: currentResult, oper: name)
        case .equals:
            guard let pbo = pendingBinaryOperation else {
                return
            }
            currentResult = pbo.perform(with: currentResult)
            pendingBinaryOperation = nil
            pendingOperationWasPerformed = true

        case .redo:
            redo()
        case .undo:
            undo()
        }
    }
    private func performPendingBinaryOperation() {
        guard pendingBinaryOperation != nil,
            let value = (pendingBinaryOperation?.perform(with: currentResult)) else {
                return
        }
        currentResult = value
        pendingBinaryOperation = nil
    }

    func clear() {
        currentResult = 0
        history.removeAll()
    }

    func setNumber(input: String) {
        guard let num = Double(input) else {
            return
        }
        currentResult = num
        saveResult(value: num, oper: nil)
    }

    func switchRadianMode() {
        radianMode = !radianMode
    }

    private func undo() {
        if let (value, function) = history.pop() {
            recoverOperation(value, function)
        }
    }

    private func redo() {
        if let (value, function) = history.next() {
            recoverOperation(value, function)
        }
    }

    private func recoverOperation(_ value: Double, _ operation: AvailableOperation?) {
        recoveringFromHistory = true
        currentResult = value
        if let symbol = operation {
            performOperationByName(name: symbol.rawValue)
        } else {
            pendingBinaryOperation = nil
        }
        currentResult = value
        recoveringFromHistory = false
    }

    private func saveResult(value: Double, oper: String?) {
        guard let oper = oper,
            !recoveringFromHistory else {
                return
        }
        guard let operType = AvailableOperation(rawValue: oper) else {
            history.push(num: value)
            return
        }
        history.push(num: value, oper: operType)
    }
}

fileprivate extension Calculator {
     struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstValue: Double
        let oper: String

        func perform (with secondValue: Double) -> Double {
            return (function(firstValue, secondValue))
        }
    }
}
