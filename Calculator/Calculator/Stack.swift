import Foundation

struct Stack<Element> {
    fileprivate var array: [Element] = []
    fileprivate var writeIndex: Int = 0

    mutating func push(_ element: Element) {
        if writeIndex < array.count {
            array.removeSubrange((writeIndex)...(array.count-1))
        }
        array.append(element)
        writeIndex += 1
    }

    mutating func pop() -> Element? {
        if array.isEmpty || (writeIndex == 0) {
            return nil
        }
        writeIndex -= 1
        let elem = array[writeIndex]
        return elem
    }

    mutating func unPop() -> Element? {
        if array.count == 0 {
            return nil
        }
        if (writeIndex + 1) <= array.count{
            writeIndex += 1
        }
        
        return array[writeIndex-1]
    }

    mutating func clear() {
        array.removeAll()
        writeIndex = 0
    }

    func top() -> Element? {
        return array.last
    }

    func isEmpty() -> Bool {
        return writeIndex == 0
    }

    func size() -> Int {
        return array.count
    }
}
