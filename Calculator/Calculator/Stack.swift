import UIKit

class Stack<Element> {
    var isEmpty: Bool {
        return array.isEmpty
    }
    private var array: [Element] = []

    func push(_ element: Element) {
        array.append(element)
    }

    func pop() -> Element? {
        return array.popLast()
    }

    func clear() {
        return array.removeAll()
    }
}
