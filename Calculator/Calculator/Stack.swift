import Foundation

// Не final т.к. нам в будущем может пригодиться расширить
class Stack {
    private enum StackElement {
        case number(Double)
        case operation(Double, AvailableOperation)
    }

    private var stackPointer = -1
    private var values: [StackElement] = []
    var isEmpty: Bool {
        return values.isEmpty
    }
    var size: Int {
        return values.count
    }

    func push(num: Double) {
        values.append(.number(num))
        stackPointer += 1
    }

    func pop() -> (Double, AvailableOperation?)? {
        guard stackPointer >= 0 else {
            return nil }
        switch values[stackPointer] {
        case .number(let number):
            stackPointer -= 1
            return (number, nil)
        case .operation(let number, let oper):
            stackPointer -= 1
            return (number, oper)
        }
    }

    func push(num: Double, oper: String?) {
        guard let oper = oper,
            let operType = AvailableOperation(rawValue: oper) else {
                push(num: num)
                return
        }
        values.append(.operation(num, operType))
        stackPointer+=1
    }

    func push(num: Double, oper: AvailableOperation?) {
        guard let oper = oper else {
            push(num: num)
            return
        }
        values.append(.operation(num, oper))
        stackPointer+=1
    }

    func next() -> (Double, AvailableOperation?)? {
        if stackPointer < values.count - 1 {
            stackPointer += 1
            switch values[stackPointer] {
            case .number(let number):
                stackPointer -= 1
                return (number, nil)
            case .operation(let number, let oper):
                stackPointer -= 1
                return (number, oper)
            }
        } else {
            return nil
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
