import Foundation

// Не final т.к. нам в будущем может пригодиться расширить
class Stack {
    private var stackPointer = -1
    private var values: [KindOfOperation] = []

    func push(num: Double) {
        values.append(.number(num))
        stackPointer += 1
    }

    func pop() -> (Double, AvailableOperations?)? {
        if stackPointer >= 0 {
            switch values[stackPointer] {
            case .number(let number):
                return (number, nil)
            case .operation(let number, let oper):
                return (number, oper)
            }
        }
        return nil
    }

    func push(num: Double, oper: AvailableOperations?) {
        guard let oper = oper else {
            push(num: num)
            return
        }
        values.append(.operation(num, oper))
    }

    func isEmpty() -> Bool {
        return values.isEmpty
    }

    func size() -> Int {
        return values.count
    }

    func next() {
        if stackPointer < values.count - 1 {
            stackPointer += 1
        }
    }

    func past() {
        if stackPointer > 0 {
            stackPointer -= 1
        }
    }

    func removeAll() {
        values.removeAll()
    }
}
