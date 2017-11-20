//
//  UnaryOperation.swift
//  CalculatorProject
//
//  Created by Alexander on 30.10.17.
//  Copyright © 2017 Kas. All rights reserved.
//

import Foundation

enum UnaryOperation: String, EnumCollection {
    case changeSign = "±"
    case lg = "lg"
    case tan = "tan"
    case cos = "cos"
    case sin = "sin"
    case sqrt = "√x"
    case square = "x^2"
    case inverse = "1/x"
    case percent = "﹪"
    case tenPowX = "10^x"
    case ln = "ln"
    case exp = "e^x"
    case tanh = "tanh"
    case cube = "x^3"
    case cubeRoot = "x^(1/3)"
    case cosh = "cosh"
    case sinh = "sinh"
    case factorial = "x!"
    case asinh = "sinh⁻¹"
    case acosh = "cosh⁻¹"
    case atanh = "tanh⁻¹"
    case asin = "sin⁻¹"
    case acos = "cos⁻¹"
    case atan = "tan⁻¹"
    case exp2 = "2^x"
    case log2 = "log 2"
}
