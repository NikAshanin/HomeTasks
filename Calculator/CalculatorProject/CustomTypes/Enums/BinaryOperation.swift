//
//  BinaryOperation.swift
//  CalculatorProject
//
//  Created by Alexander on 30.10.17.
//  Copyright © 2017 Kas. All rights reserved.
//

import Foundation

enum BinaryOperation: String, EnumCollection {
    case pow = "x^y"
    case mod = "mod"
    case plus = "+"
    case multiply = "×"
    case division = "÷"
    case minus = "−"
    case EE = "EE"
    case powReverse = "x^(1/y)"
    case yPowX = "y^x"
    case logY = "log y"
}
