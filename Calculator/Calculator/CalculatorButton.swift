//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Artem Orlov on 02/11/2017.

import UIKit

class CalculatorButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
