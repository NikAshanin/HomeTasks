import Foundation

final class StackElement<T> {
    private var value: T
    private var nextElement: StackElement?

    init(value: T) {
        self.value = value
    }

    init(value: T, nextElement: StackElement?) {
        self.value = value
        self.nextElement = nextElement
    }

    func isNumberValue() -> Bool {
        return value is Double
    }

    func getValue() -> T {
        return value
    }

    func setNextElement(nextElement: StackElement?) {
        self.nextElement = nextElement
    }

    func getNextElement() -> StackElement? {
        return nextElement
    }
}
