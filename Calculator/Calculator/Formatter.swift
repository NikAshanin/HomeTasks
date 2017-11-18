//
//  Formatter.swift
//  Calculator
//
//  Created by Artem Orlov on 18/11/2017.
//

import Foundation

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    formatter.locale = .current
    formatter.maximumFractionDigits = 9
    return formatter
}()
