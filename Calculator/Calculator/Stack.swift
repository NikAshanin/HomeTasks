import Foundation

final class Stack {

    init() {
        push(value: 0.0, fun: nil)
    }

    enum Operators {
        case number(Double)
        case operation((Double, String))
    }

     private var history: [Operators] = []

    private var currentSymbol = -1 {
        didSet {
            if currentSymbol <= -1 {
                print("\([])")
            } else {
                print("\(history[0...currentSymbol])")
            }
        }
    }

    var isEmpty: Bool {
        return currentSymbol<=0
    }

    var isFull: Bool {
        return currentSymbol.distance(to: history.count) == 1
    }

    func push(value: Double, fun: String?) {
        if let fun = fun {
            history.append(Operators.operation((value, fun)))
        } else {
            history.append(Operators.number(value))
        }
        currentSymbol+=1
    }

    func pop() -> (Double, String?)? {
        if isEmpty {
            return nil
        }
        currentSymbol-=1
        let oper = history[currentSymbol]
        switch oper {
        case .number(let value):
            return (value, nil)
        case .operation(let value, let fun):
            return (value, fun)
        }
    }

    func goForward() -> (Double, String?)? {
        if isFull {
            return nil
        } else {
            currentSymbol+=1
            let oper = history[currentSymbol]
            switch oper {
            case .number(let value):
                return (value, nil)
            case .operation(let value, let fun):
                return (value, fun)
            }
        }
    }
}
