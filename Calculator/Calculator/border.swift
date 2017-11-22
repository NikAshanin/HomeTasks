//
//  border.swift
//  calc
//
//  Created by Sergey Gusev on 02.11.2017.
//  Copyright © 2017 Sergey Gusev. All rights reserved.
//

import UIKit

@IBDesignable class RoundBotton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
