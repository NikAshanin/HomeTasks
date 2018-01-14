import Foundation

final class DescriptionHandler {

    // MARK: - Properties

    private enum Constants: String {
        case space = " "
    }

    private var unaryOperations: Set = ["1/x", "2√x", "∛x", "e^x", "10^x", "2^x"]
    private var description = ""
    private var lastOperation = ""
    private let operations = Operations()
    private let formatter = NumberFormatterConfigurator()

    // MARK: - Public properties

    var getDescription: String? {
        return description
    }

    // MARK: - Public

    func addToDescription(digit: String? = nil, symbol: String? = nil, resultIsPending: Bool) {

        if let digit = digit {
            guard let digit = Double(digit) else {
                assertionFailure("Cant format to Double")
                return
            }

            guard let formattedDigit = formatter.string(from: NSNumber(value: digit)) else {
                assertionFailure("Cant format")
                return
            }

            description += formattedDigit + Constants.space.rawValue
        } else if symbol != nil {
            guard let symbol = symbol else {
                return
            }

            addOperationToDesccription(symbol, resultIsPending: resultIsPending)
        }
    }

    func cleanDescription() {
        description = ""
    }

    // MARK: - Private

    private func addOperationToDesccription(_ symbol: String, resultIsPending: Bool) {
        guard let operation = operations.operations[symbol] else {
            return
        }

        switch operation {
        case .constant:
            description += symbol + Constants.space.rawValue
        case .unaryOperation where unaryOperations.contains(symbol):

            var mutableSymbol = String(symbol)
            mutableSymbol.removeLast(1)

            if resultIsPending {
                description += mutableSymbol + "\(returnLastNumberFromDescription())" + Constants.space.rawValue
            } else {
                description = mutableSymbol + "(\(description))" + Constants.space.rawValue
            }
        case .unaryOperation:
            if resultIsPending {
                description += symbol + "(\(returnLastNumberFromDescription()))" + Constants.space.rawValue
            } else {
                description = symbol + "(\(description))" + Constants.space.rawValue
            }
        case .binaryOperation where symbol == "y√x" || symbol == "x^y":
            lastOperation = symbol

            var mutableSymbol = String(symbol)
            mutableSymbol.removeLast(1)

            description = mutableSymbol + "(\(description))" + Constants.space.rawValue
        case .binaryOperation:
            description += symbol + Constants.space.rawValue
        case .equals where lastOperation == "y√x" || lastOperation == "x^y":
            description.removeFirst(1)
            description = returnLastNumberFromDescription() + "\(description)" + Constants.space.rawValue
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
