import Foundation

class OperationStackController {
    enum OpStack {
        case number(Double)
        case operation((Double, String))
    }
    private var internalProgram: [OpStack] = []
    private var currentSymbol = -1
    var lastValueInStack: Bool {
        return currentSymbol.distance(to: internalProgram.count) == 1
    }
    func push(operand: Double, operation: String?) {
        if let operation = operation {
            internalProgram.append(OpStack.operation((operand, operation)))
        } else {
            internalProgram.append(OpStack.operation((operand, "")))
        }
        currentSymbol+=1
    }
    func undo() -> (Double, String?)? {
        if internalProgram.isEmpty {
            return nil
        }
        let oper = internalProgram[currentSymbol]
        currentSymbol-=1
        switch oper {
        case .number(let value):
            return (value, nil)
        case .operation(let value, let fun):
            return (value, fun)
        }
    }
    func redo() -> (Double, String?)? {
        if lastValueInStack {
            return nil
        } else {
            currentSymbol+=1
            let oper = internalProgram[currentSymbol]
            switch oper {
            case .number(let value):
                return (value, nil)
            case .operation(let value, let fun):
                return (value, fun)
            }
        }
    }
    func clear() {
        internalProgram.removeAll()
        currentSymbol = -1
    }
}
