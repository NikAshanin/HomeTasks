import Foundation

final class CalculatorService {
    // MARK: - Properties
    // Dicionaries for buttons labels
    static let changingButtonsNamesArray = [ ["Off": UnaryOperation.sinh.rawValue, "On": UnaryOperation.asinh.rawValue],
                                             ["Off": UnaryOperation.cosh.rawValue, "On": UnaryOperation.acosh.rawValue],
                                             ["Off": UnaryOperation.tanh.rawValue, "On": UnaryOperation.atanh.rawValue],
                                             ["Off": UnaryOperation.sin.rawValue, "On": UnaryOperation.asin.rawValue],
                                             ["Off": UnaryOperation.cos.rawValue, "On": UnaryOperation.acos.rawValue],
                                             ["Off": UnaryOperation.tan.rawValue, "On": UnaryOperation.atan.rawValue],
                                             ["Off": UnaryOperation.logE.rawValue, "On": BinaryOperation.logY.rawValue],
                                             ["Off": UnaryOperation.log10.rawValue, "On": UnaryOperation.log2.rawValue],
                                             ["Off": UnaryOperation.exp.rawValue, "On": BinaryOperation.yPowX.rawValue],
                                             ["Off": UnaryOperation.tenPowX.rawValue, "On": UnaryOperation.exp2.rawValue]
    ]

    static let unaryOperationsDictionary: [UnaryOperation: (Double) -> (Double)] = [
        .changeSign: { -$0 },
        .log10: { log10($0) },
        .tan: { tan(getRadianValue(value: $0)) },
        .cos: { cos(getRadianValue(value: $0)) },
        .sin: { sin(getRadianValue(value: $0)) },
        .sqrt: { sqrt($0) },
        .square: { $0 * $0 },
        .inverse: { 1 / $0 },
        .percent: { $0 / 100 },
        .tenPowX: { __exp10($0) },
        .logE: { log($0) },
        .exp: { pow(M_E, $0) },
        .tanh: { tan($0) },
        .cube: { $0 * $0 * $0 },
        .cubeRoot: { pow($0, 1 / 3) },
        .cosh: { cosh($0) },
        .sinh: { sinh($0) },
        .factorial: { factorialFunction(value: $0) },
        .asinh: { asinh($0) },
        .atanh: { atanh($0) },
        .asin: { asin($0) },
        .acos: { acos($0) },
        .atan: { atan($0) },
        .exp2: { pow(2, $0) },
        .log2: { log2($0) }
    ]

    static let nullaryOperationsDictionary: [NullaryOperation: Double] = [
        .random: Double(arc4random()),
        .eNumber: M_E,
        .piNumber: .pi
    ]

    static let binaryOperationsDictionary: [BinaryOperation: (Double, Double) -> Double] = [
        .pow: { pow($0, $1) },
        .mod: { fmod($0, $1) },
        .plus: { $0 + $1 },
        .multiply: { $0 * $1 },
        .division: { $0 / $1 },
        .minus: { $0 - $1 },
        .EEOperation: { $0 * pow(10, $1) },
        .powReverse: { pow($0, 1 / $1) },
        .yPowX: { pow($1, $0) },
        .logY: { log($0) / log($1) }
    ]

    // Properties for binary operations
    private static var firstOperand: Double?
    private static var binaryOperation: BinaryOperation?

    //Property for trigonometric functions
    private static var isRadianValue: Bool = false

    // Properties for memory buttons
    private static var valueInMemory: Double?

    // MARK: - Operations methods
    static func binaryOperation(firstOperand: Double, operation: BinaryOperation) -> Double {
        if self.firstOperand != nil && binaryOperation != nil {
            // In case when we get result by calling another binary operation
            //
            // Also if you use operations like this the result will be in stack twice,
            // because this number is used for 2 different operations
            self.firstOperand = resultOperation(second: firstOperand)
            StackHelper.previousActionsStack.push(value: firstOperand)
            StackHelper.previousActionsStack.push(value: operation.rawValue)
        } else {
            StackHelper.previousActionsStack.push(value: firstOperand)
            StackHelper.previousActionsStack.push(value: operation.rawValue)
            self.firstOperand = firstOperand
        }
        binaryOperation = operation
        return self.firstOperand ?? firstOperand
    }

    static func unaryOperation(value: Double, operation: UnaryOperation, withRadians: Bool) -> Double? {
        StackHelper.previousActionsStack.push(value: value)
        StackHelper.previousActionsStack.push(value: operation.rawValue)
        isRadianValue = withRadians
        guard let result = unaryOperationsDictionary[operation] else {
            return nil
        }
        return result(value)
    }

    static func nullaryOperation(operation: NullaryOperation) -> Double? {
        StackHelper.previousActionsStack.push(value: operation.rawValue)
        guard let result = nullaryOperationsDictionary[operation] else {
            return nil
        }
        return result
    }

    static func memoryOperation(value: Double, operation: MemoryOperation) -> Double? {
        switch operation {
        case .memoryPlus:
            valueInMemory = value
            return value
        case .clearMemory:
            valueInMemory = nil
            return nil
        case .readFromMemory:
            return valueInMemory
        case .memoryMinus:
            return nil
        }
    }

    static func resultOperation(second: Double) -> Double? {
        guard let first = firstOperand, let operation = binaryOperation else {
            return nil
        }
        firstOperand = nil
        binaryOperation = nil
        StackHelper.previousActionsStack.push(value: second)
        guard let resultOperation = binaryOperationsDictionary[operation] else {
            return nil
        }
        let result = resultOperation(first, second)
        StackHelper.resultsStack.push(value: result)
        return result
    }

    // MARK: - Other methods
    private static func factorialFunction(value: Double) -> Double {
        var result: Double = 1
        for i in 2...Int(value) {
            result *= Double(i)
        }
        return result
    }

    private static func getRadianValue(value: Double) -> Double {
        return isRadianValue ? value * Double.pi / 180 : value
    }
}
