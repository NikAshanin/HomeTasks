//
//  CircleView.swift
//  Circle_Gesture
//
//  Created by Artem Orlov on 08/11/2017.
//

import UIKit

class CircleView: UIView {

    let lineWidth: CGFloat = 50

    override func draw(_ rect: CGRect) {
        // Drawing code
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: (bounds.width - lineWidth) / 2,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        circlePath.lineWidth = lineWidth
        circlePath.stroke()
    }

}
