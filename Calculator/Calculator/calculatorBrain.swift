//
//  calculatorBrain.swift
//  calc
//
//  Created by Sergey Gusev on 29.10.2017.
//  Copyright © 2017 Sergey Gusev. All rights reserved.
//

import Foundation
private func factorial(operand: Double) -> Double {
    var fact = 1.0
    let n = Int(operand + 1)
    for i in 1...n {
        let multiply = Double(i)
        fact *= multiply
    }
    return Double(fact)
}
struct CalculatorBrain {
    private var accumulator: Double?
    private enum Operation {
        case constant(Double)
        case nulOperation(() -> Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case triginimetryOperation((Double) -> Double)
        case equals
    }
    private var operations = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√x": Operation.unaryOperation(sqrt),
        "cos": Operation.triginimetryOperation(cos),
        "+/_": Operation.unaryOperation({-$0}), //chabge to $
        "%": Operation.unaryOperation({$0 / 100}),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "EE": Operation.binaryOperation({$0 * pow(10.0, $1)}),
        "x²": Operation.unaryOperation({pow($0, (2))}),
        "x³": Operation.unaryOperation({pow($0, (3))}),
        "xʸ": Operation.binaryOperation({pow($0, $1)}),
        "eˣ": Operation.unaryOperation({pow(M_E, $0)}),
        "10ˣ": Operation.unaryOperation({pow(10, $0)}),
        "1/x": Operation.unaryOperation({1 / $0}),
        "∛x": Operation.unaryOperation({pow($0, (1/3))}),
        "ʸ√x": Operation.binaryOperation({pow($0, (1/$1))}),
        "ln": Operation.unaryOperation({log($0)}),
        "log₁₀": Operation.unaryOperation({log($0)/log(10.0)}),
        "x!": Operation.unaryOperation({factorial(operand: $0)}),
        "sin": Operation.triginimetryOperation(sin),
        "tan": Operation.triginimetryOperation(tan),
        "sinh": Operation.triginimetryOperation(sinh),
        "cosh": Operation.triginimetryOperation(cosh),
        "tanh": Operation.triginimetryOperation(tanh),
        "Rand": Operation.nulOperation(drand48),
        "yˣ": Operation.binaryOperation({pow($0, $1)}),
        "2ˣ": Operation.unaryOperation({pow(2, $0)}),
        "logᵧ": Operation.binaryOperation({log($0)/log($1)}),
        "log₂": Operation.unaryOperation({log($0)/log(2.0)}),
        "sin⁻¹": Operation.triginimetryOperation({asin($0) * 180 / Double.pi}),
        "cos⁻¹": Operation.triginimetryOperation({acos($0) * 180 / Double.pi}),
        "tan⁻¹": Operation.triginimetryOperation({atan($0) * 180 / Double.pi}),
        "sinh⁻¹": Operation.triginimetryOperation({asinh($0) * 180 / Double.pi}),
        "cosh⁻¹": Operation.triginimetryOperation({acosh($0) * 180 / Double.pi}),
        "tanh⁻¹": Operation.triginimetryOperation({atanh($0) * 180 / Double.pi}),
        "=": Operation.equals
    ]
    private var isRadian = false
    mutating func setIsRadian(_ isRadian: Bool) {
        self.isRadian = isRadian
    }
    mutating func perfomOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .nulOperation(let function):
                accumulator = function()
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                performPendingBinaryOperation()
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                   // accumulator = nil
                }
                //accumulator = nil
            case .triginimetryOperation(let function):
                if accumulator != nil {
                    if isRadian {
                        accumulator = function(accumulator!)
                    } else {
                        accumulator = function(accumulator! * Double.pi / 180.0)
                    }
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    private var pendingBinaryOperation: PendingBinaryOperation?
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    var result: Double? {
        return accumulator
    }
    mutating func clear() {
        accumulator = 0.0
        pendingBinaryOperation = nil
    }
}
let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 6
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
} ()
