import Foundation

final class Calculator {
    private var history = Stack()
    var currentResult: Double = 0
    private let calcBrain = CalculatorBrain()
    var radianMode = false

    func performOperationByName(name: String) {
        if name == "=" {
            solve()
        }
        guard let oper = AvailableOperations(rawValue: name),
              let operation = calcBrain.ops[oper] else {
            return
        }

        switch name {
        case "sqrt", "3sqrt":
            name == "sqrt" ? sqrt(pow: 2, operation) : sqrt(pow: 3, operation)
        case "x^2", "x^3", "e^x", "10^x":
            pow(action: name, operation)
        case "1/x":
            currentResult = operation(1, currentResult)
        case "x!":
            currentResult = operation(currentResult, currentResult)
        case "ln", "log10":
            name == "ln" ? log(pow: M_E, operation) : log(pow: 10, operation)
        case "sin", "cos", "tan", "sinh", "cosh", "tanh", "sin^-1", "cos^-1", "tan^-1", "sinh^-1", "cosh^-1", "tanh^-1":
            radianMode ? (currentResult = operation(currentResult, currentResult) * 180 / Double.pi) :
                    (currentResult = operation(currentResult, currentResult))
        case "<-", "->":
            name == "<-" ? history.past() : history.next()
        default:
            doMath(userInput: name, oper)
        }
    }

    func clearHistory() {
        history.removeAll()
    }

    func addInHistory(input: String) {
        guard let num = Double(input) else {
            return
        }
        history.push(num: num)
    }

    private func solve() {
            guard let (secondNumber, operation) = history.pop()
                else {
                    return
            }
            guard let oper = operation,
                let res = calcBrain.ops[oper] else {
                    return
            }
            currentResult = res(secondNumber, currentResult)
            history.push(num: currentResult)
    }

    private func sqrt(pow: Double, _ operation: ((Double, Double) -> Double)) {
        currentResult = operation(currentResult, pow)
    }

    private func pow(action: String, _ operation: ((Double, Double) -> Double)) {
        switch action {
        case "x^2":
            currentResult = operation(currentResult, 2)
        case "x^3":
            currentResult = operation(currentResult, 3)
        case "e^x":
            currentResult = operation(M_E, currentResult)
        case "10^x":
            currentResult = operation(10, currentResult)
        case "2^x":
            currentResult = operation(2, currentResult)
        default: break
        }
    }

    private func doMath(userInput: String, _ newOp: AvailableOperations) {
        if userInput != "" && !history.isEmpty() {
            guard let (secondNumber, lastOp) = history.pop() else {
                return
            }
            if !((lastOp == .plus || lastOp == .minus) &&
                (newOp == .multiply || newOp == .divide || newOp == .numberPow || newOp == .sqrt)) {
                guard let op = lastOp,
                    let oper = calcBrain.ops[op] else {
                        return
                }
                currentResult = oper(secondNumber, currentResult)
                history.push(num: currentResult)
                self.solve()
            }
        }
        history.push(num: currentResult, oper: newOp)
    }

    private func log(pow: Double, _ operation: ((Double, Double) -> Double)) {
        currentResult = operation(pow, currentResult)
    }
}
