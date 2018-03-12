//
//  CalculatorInput.swift
//  Calculator
//
//  Created by Антон Назаров on 16.11.2017.
//

protocol CalculatorInput {
  var input: String! { get set }
  weak var output: CaclulatorDelegate? { get set }

  func undo()
}
