//
//  CalculatorService.swift
//  CalculatorProject
//
//  Created by Kas on 25/10/2017.
//  Copyright © 2017 Kas. All rights reserved.
//

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
                                             ["Off": UnaryOperation.ln.rawValue, "On": BinaryOperation.logY.rawValue],
                                             ["Off": UnaryOperation.lg.rawValue, "On": UnaryOperation.log2.rawValue],
                                             ["Off": UnaryOperation.exp.rawValue, "On": BinaryOperation.yPowX.rawValue],
                                             ["Off": UnaryOperation.tenPowX.rawValue, "On": UnaryOperation.exp2.rawValue]
    ]
    
    // Properties for binary operations
    private static var firstOperand: Double?
    private static var binaryOperation: BinaryOperation?
    
    // Properties for memory buttons
    private static var valueInMemory: Double?
    
    // MARK: - Operations methods
    static func binaryOperation(firstOperand: Double, operation: BinaryOperation) -> Double {
        if self.firstOperand != nil && binaryOperation != nil {
            // in case when we have got result by calling another binary operation
            // also if you use operations like this the result will be in stack twice, because this number is used for 2 different operations
            self.firstOperand = resultOperation(second: firstOperand)
            StackService.previousActionsStack.push(value: firstOperand)
            StackService.previousActionsStack.push(value: operation.rawValue)
        } else {
            StackService.previousActionsStack.push(value: firstOperand)
            StackService.previousActionsStack.push(value: operation.rawValue)
            self.firstOperand = firstOperand
        }
        binaryOperation = operation
        return self.firstOperand ?? firstOperand
    }
    
    static func unaryOperation(value: Double, operation: UnaryOperation, withRadians: Bool) -> Double? {
        StackService.previousActionsStack.push(value: value)
        StackService.previousActionsStack.push(value: operation.rawValue)
        let parameter = !withRadians ? value * Double.pi / 180 : value
        switch operation {
        case .changeSign:
            return -value
        case .lg:
            if value > 0 {
                return log10(value)
            } else {
                AlertService.showAlert(title: "Number is nonpositive!", message: "Enter another number for log() function")
                return value
            }
        case .tan:
            return tan(parameter)
        case .cos:
            return cos(parameter)
        case .sin:
            return sin(parameter)
        case .sqrt:
            if value >= 0 {
                return sqrt(value)
            } else {
                AlertService.showAlert(title: "Number is negative!", message: "Enter another number for sqrt() function")
                return value
            }
        case .square:
            return value * value
        case .inverse:
            if value != 0 {
                return 1 / value
            } else {
                AlertService.showAlert(title: "Number equals zero!", message: "Enter another number for 1/x function")
                return value
            }
        case .percent:
            return value / 100
        case .tenPowX:
            return __exp10(value)
        case .ln:
            return log(value)
        case .exp:
            return pow(M_E, value)
        case .tanh:
            return tanh(value)
        case .cosh:
            return cosh(value)
        case .cube:
            return value * value * value
        case .cubeRoot:
            return pow(value, 1 / 3)
        case .factorial:
            var result: Double = 1
            for i in 2...Int(value) {
                result *= Double(i)
            }
            return result
        case .sinh:
            return sinh(value)
        case .asin:
            return asin(value)
        case .acos:
            return acos(value)
        case .atan:
            return atan(value)
        case .asinh:
            return asinh(value)
        case .acosh:
            return acosh(value)
        case .atanh:
            return atanh(value)
        case .log2:
            return log2(value)
        case .exp2:
            return pow(2, value)
        }
    }
    
    static func nullaryOperation(operation: NullaryOperation) -> Double? {
        StackService.previousActionsStack.push(value: operation.rawValue)
        switch operation {
        case .random:
            return Double(arc4random())
        case .eNumber:
            return M_E
        case .piNumber:
            return .pi
        }
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
        if let first = firstOperand, let operation = binaryOperation {
            firstOperand = nil
            binaryOperation = nil
            StackService.previousActionsStack.push(value: second)
            var result = 0.0
            switch operation {
            case .pow:
                result = pow(first, second)
            case .mod:
                if second != 0 {
                    result = fmod(first, second)
                } else {
                    AlertService.showAlert(title: "Division by zero!", message: "Retarded!")
                    result = second
                }
            case .division:
                if second != 0 {
                    result = first / second
                } else {
                    AlertService.showAlert(title: "Division by zero!", message: "Retarded!")
                    result = second
                }
            case .multiply:
                result = first * second
            case .minus:
                result = first - second
            case .plus:
                result = first + second
            case .EE:
                result = first * pow(10, second)
            case .powReverse:
                result = pow(first, 1 / second)
            case .yPowX:
                result = pow(second, first)
            case .logY:
                result = log(first) / log(second)
            }
            StackService.resultsStack.push(value: result)
            return result
        } else {
            return nil
        }
    }
}
