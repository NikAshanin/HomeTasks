import Foundation

final class StackHelper {
    static let previousActionsStack = Stack()
    static let nextActionsStack = Stack()
    static let resultsStack = Stack()

    private static var wasBinaryActionBefore = false

    static func undo() -> String {
        if let stackElement = previousActionsStack.pop() {
            if stackElement.isNumberValue() {
                let value = stackElement.getValue()
                nextActionsStack.push(value: value)
                return String(describing: value)
            } else {
                let value = stackElement.getValue()
                nextActionsStack.push(value: value)
                return String(describing: value)
            }
        } else {
            return "0"
        }
    }

    static func redo() -> String {
        if let stackElement = nextActionsStack.pop() {
            if stackElement.isNumberValue() {
                let value = stackElement.getValue()
                previousActionsStack.push(value: value)
                return String(describing: value)
            } else {
                let value = stackElement.getValue()
                previousActionsStack.push(value: value)
                return String(describing: value)
            }
        } else {
            return "0"
        }
    }
}
