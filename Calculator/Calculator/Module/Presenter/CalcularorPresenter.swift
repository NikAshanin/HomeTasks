//
//  CalcularorViewModel.swift
//  Calculator
//
//  Created by Антон Назаров on 26.10.2017.
//

import Foundation

class CalculatorPresenter: CalculatorInput {
  private var firstOperand: String?
  private var currentOperandHistory = Stack<String>()
  private var rememberedOperator: String?
  weak var output: CaclulatorDelegate?
  var input: String! {
    didSet {
      output?.set(result: newResult(from: input))
    }
  }

  func undo() {
    if !currentOperandHistory.isEmpty {
      _ = currentOperandHistory.pop()
    }
    output?.set(result: currentOperandHistory.peek() ?? Constant.ZERO)
  }

  func newResult(from input: String) -> String {
    return isSymbolPartOfNumber(input) ? getNum(input) : getCurrentResult(input)
  }

  func getNum(_ input: String) -> String {
    let lastFromHistory =  currentOperandHistory.peek() ?? ""
    let withoutFirstZeroSymbol = lastFromHistory == "0" ? "" : lastFromHistory
    let newValue = withoutFirstZeroSymbol + (input == "," ? "." : input)

    guard Double(newValue) != nil else {
      return  lastFromHistory
    }
    currentOperandHistory.push(newValue)
    return newValue
  }

  func getCurrentResult(_ input: String) -> String {
    switch input {
    case "AC":
      clearAll()
      return Constant.ZERO
    case "+/-":
      return negateDisplayValue()
    default:
      return handleOperation(input)
    }
  }

  private func handleOperation(_ input: String) -> String {
    guard let first = firstOperand, let remembered = rememberedOperator else {
      firstOperand = currentOperandHistory.peek()
      rememberedOperator = input
      currentOperandHistory.clear()
      return firstOperand ?? Constant.ZERO
    }

    if let secondOperator = currentOperandHistory.peek() {
      let result = calculate(left: first, oper: remembered, right: secondOperator)
      rememberedOperator = (input == "=") ? nil : input
      currentOperandHistory.clear()
      firstOperand = result
      return result
    } else {
      rememberedOperator = input
      return first
    }
  }

  private func negateDisplayValue() -> String {
    var screenValue: String
    if let first = firstOperand {
      screenValue = first
    } else {
      screenValue = currentOperandHistory.peek() ?? Constant.ZERO
    }
    let result = toStringRound(negative(Double(screenValue) ?? 0))
    currentOperandHistory.push(result)
    return result
  }

  private func clearAll() {
    firstOperand = nil
    rememberedOperator = nil
    currentOperandHistory.clear()
  }
}

// MARK: math
extension CalculatorPresenter {
  func toStringRound(_ num: Double) -> String {
    return num.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(num)) : String(num)
  }

  func negative(_ num: Double) -> Double {
    return num * -1
  }

  func isSymbolPartOfNumber(_ input: String) -> Bool {
    return Int(input) != nil || input == ","
  }

  func calculate(left: String, oper: String, right: String) -> String {
    var result: Double = 0.0
    guard let rhs = Double(right), let lhs = Double(left) else {
      return toStringRound(result)
    }
    switch oper {
    case "+":
      result = lhs + rhs
    case "-":
      result = lhs - rhs
    case "*":
      result = lhs * rhs
    case "/":
      result = lhs / rhs
    case "%":
      result = fmod(lhs, rhs)
    default:
      fatalError("Not implementeted operation")
    }
    return toStringRound(result)
  }
}
