//
//  ORecognizer.swift
//  OwithTab
//
//  Created by Sitora on 08.11.17.
//  Copyright © 2017 Ira. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

let numberpi = CGFloat(M_PI)
extension CGFloat {
    var degrees: CGFloat {
        return self * 180 / numberpi
    }
}

class ORecognizer: UIGestureRecognizer {
    // midpoint for gesture recognizer
    var midPoint = CGPoint.zero
    // minimal distance from midpoint
    var innerX: CGFloat?
    var innerY: CGFloat?
    var firstAngle: CGFloat?
    // maximal distance to midpoint
    var outerX: CGFloat?
    var outerY: CGFloat?
    var strokePart: UInt = 0
    // absolute angle for current gesture (in radians)
    var angle: CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.angleForPoint(point: nowPoint)
        }
        return nil
    }
    var absX: CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.absForX(pointA: self.midPoint, andPointB: nowPoint)
        }
        return nil
    }
    var absY: CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.absForY(pointA: self.midPoint, andPointB: nowPoint)
        }
        return nil
    }
    /* PRIVATE VARS */
    // internal usage for calculations
    var currentPoint: CGPoint?
    var previousPoint: CGPoint?
    /* PUBLIC METHODS */
    // designated initializer
    init(midPoint: CGPoint, innerX: CGFloat?, innerY: CGFloat?, outerX: CGFloat?, outerY: CGFloat?, target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        self.midPoint = midPoint
        self.innerX = innerX
        self.innerY = innerY
        self.outerX = outerX
        self.outerY = outerY
    }
    // convinience initializer if innerRadius and OuterRadius are not necessary
    convenience init(midPoint: CGPoint, target: AnyObject?, action: Selector) {
        self.init(midPoint: midPoint, innerX: 80, innerY: 135, outerX: 150, outerY: 200, target:target, action: action)
    }
    /* PRIVATE METHODS */
    func angleForPoint(point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + numberpi/2
        if angle < 0 {
            angle += numberpi*2
        }
        return angle
    }
    func absForX(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dx = abs(Float(pointA.x - pointB.x))
        return CGFloat(dx*dx)
    }
    func absForY(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        let dy = abs(Float(pointA.y - pointB.y))
        return CGFloat(dy*dy)
    }
    /* SUBCLASSED METHODS */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        guard touches.count == 1 else {
            state = .failed
            return
        }
        if touches.first != nil {
            if let x = self.absX, let y = self.absY {
                if (x / (innerX! * innerX!) + y / (innerY! * innerY!)) <= 1 {
                    state = .failed
                }
                if (x / (outerX! * outerX!) + y / (outerY! * outerY!)) > 1 {
                    state = .failed
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let x = self.absX, let y = self.absY {

            if (x / (innerX! * innerX!) + y / (innerY! * innerY!)) <= 1 {
                state = .failed
            }
            if (x / (outerX! * outerX!) + y / (outerY! * outerY!)) > 1 {
                state = .failed
            }
        }
        if state == .failed {
            return
        }
        if let firstTouch = touches.first {
            currentPoint = firstTouch.location(in: self.view)
            previousPoint = firstTouch.previousLocation(in: self.view)
        }
        if strokePart == 0 &&
            (angle?.degrees)! > CGFloat(225) && (angle?.degrees)! <= CGFloat(315) {
            firstAngle = angle?.degrees
            print("continue 1")
            strokePart = 1
        } else if strokePart == 1 &&
            ((angle?.degrees)! > CGFloat(315) && (angle?.degrees)! <= CGFloat(360) ||
                (angle?.degrees)! >= CGFloat(0) && (angle?.degrees)! <= CGFloat(45)) {
            strokePart = 2
            print("continue 2")
        } else if strokePart == 2 &&
            (angle?.degrees)! > CGFloat(45) && (angle?.degrees)! <= CGFloat(135) {
            strokePart = 3
            print("continue 3")
        } else if strokePart == 3 &&
            (angle?.degrees)! > CGFloat(135) && (angle?.degrees)! <= CGFloat(225) {
            strokePart = 4
            print("continue 4")
        } else if strokePart == 4 &&
            (angle?.degrees)! > CGFloat(225) && (angle?.degrees)! <= CGFloat(firstAngle!) {
            strokePart = 5
            state = .recognized
            print("'O' recognized")
        }
    }
    override func reset() {
        super.reset()
        strokePart = 0
        currentPoint = nil
        previousPoint = nil
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }
}
