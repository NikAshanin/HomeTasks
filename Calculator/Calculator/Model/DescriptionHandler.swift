import Foundation

class DescriptionHandler {

    // MARK: - Singleton

    static let sharedInstance = DescriptionHandler()

    private init() {}

    // MARK: - Properties

    private struct Consts {
        static let space = " "
    }

    private var unaryOperations: Set = ["1/x", "2√x", "∛x", "e^x", "10^x", "2^x"]
    private var description = ""
    private var lastOperation = ""
    private var resultIsPending: Bool {
        return CalculatorProcessor.sharedInstance.resultIsPending
    }
    private var operations: [String: CalculatorProcessor.Operation] {
        return CalculatorProcessor.sharedInstance.calculatorOperations
    }
    private let formatter = NumberFormatter()

    // MARK: - Public properties

    public var getDescription: String? {
        return description
    }

    // MARK: - Public

    public func addToDescription(digit: String? = nil, symbol: String? = nil) {

        if let digit = digit {
            guard let digit = Double(digit) else {
                assertionFailure("Cant format to Double")
                return
            }

            formatter.maximumFractionDigits = 6
            formatter.minimumFractionDigits = 0
            formatter.minimumIntegerDigits = 1

            guard let formattedDigit = formatter.string(from: NSNumber(value: digit)) else {
                assertionFailure("Cant format")
                return
            }

            description += formattedDigit + Consts.space
        } else if symbol != nil {
            guard let symbol = symbol else {
                return
            }

            addOperationToDesccription(symbol)
        }
    }

    public func cleanDescription() {
        description = ""
    }

    // MARK: - Private

    private func addOperationToDesccription(_ symbol: String) {
        guard let operation = operations[symbol] else {
            return
        }

        switch operation {
        case .constant:
            description += symbol + Consts.space
        case .unaryOperation where unaryOperations.contains(symbol):

            var mutableSymbol = String(symbol)
            mutableSymbol.removeLast(1)

            if resultIsPending {
                description += mutableSymbol + "\(returnLastNumberFromDescription())" + Consts.space
            } else {
                description = mutableSymbol + "(\(description))" + Consts.space
            }
        case .unaryOperation:
            if resultIsPending {
                description += symbol + "(\(returnLastNumberFromDescription()))" + Consts.space
            } else {
                description = symbol + "(\(description))" + Consts.space
            }
        case .binaryOperation where symbol == "y√x" || symbol == "x^y":
            lastOperation = symbol

            var mutableSymbol = String(symbol)
            mutableSymbol.removeLast(1)

            description = mutableSymbol + "(\(description))" + Consts.space
        case .binaryOperation:
            description += symbol + Consts.space
        case .equals where lastOperation == "y√x" || lastOperation == "x^y":
            description.removeFirst(1)
            description = returnLastNumberFromDescription() + "\(description)" + Consts.space
            lastOperation = ""
        default: return
        }
    }

    private func returnLastNumberFromDescription() -> String {
        var lastNumber = ""
        description.removeLast(1)
        let descriptionCopy = description.replacingOccurrences(of: " ", with: "")

        for char in descriptionCopy.reversed() {
            if Double(String(char)) != nil {
                lastNumber.append(char)
                description.removeLast(1)
            } else {
                return lastNumber
            }
        }
        return String(lastNumber)
    }
}
