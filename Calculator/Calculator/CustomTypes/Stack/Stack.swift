import Foundation

final class Stack {
    private var head: StackElement<Any>?

    init() {
        head = nil
    }

    init(headElement: StackElement<Any>) {
        head = headElement
    }

    func pop() -> StackElement<Any>? {
        let result = head
        head = head?.getNextElement()
        result?.setNextElement(nextElement: nil)
        return result
    }

    func push(value: Any) {
        let stackElement = StackElement(value: value, nextElement: head)
        head = stackElement
        printAllElements()
    }

    func pick() -> StackElement<Any>? {
        return head
    }

    func printAllElements() {
        print()
        var iterator = head
        while iterator != nil {
            guard let unwrappedIterator = iterator else {
                return
            }
            if unwrappedIterator.isNumberValue() {
                print(iterator?.getValue() ?? 0)
            } else {
                print(iterator?.getValue() ?? 0)
            }
            iterator = iterator?.getNextElement()
        }
    }
}
