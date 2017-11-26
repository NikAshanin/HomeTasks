import UIKit

public struct Stack<Element> {
    public var isEmpty: Bool {
        return array.isEmpty
    }
    private var array: [Element] = []

    mutating public func push(_ element: Element) {
        array.append(element)
    }

    mutating public func pop() -> Element? {
        return array.popLast()
    }

    mutating public func clear() {
        return array.removeAll()
    }
}
