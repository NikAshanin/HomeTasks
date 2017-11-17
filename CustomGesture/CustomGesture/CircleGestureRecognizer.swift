//
//  CircleGestureRecognizer.swift
//  Circle_Gesture
//
//  Created by Artem Orlov on 08/11/2017.
//

import UIKit.UIGestureRecognizerSubclass

class CircleGestureRecognizer: UIGestureRecognizer {

    var innerRadius: CGFloat?
    var outerRadius: CGFloat?
    var midPoint = CGPoint.zero

    var distance: CGFloat? {

        if let newPoint = currentPoint {
            return distanceBetween(pointA: midPoint, and: newPoint)
        }
        return nil
    }

    init(midPoint: CGPoint, innerRadius: CGFloat?, outerRadius: CGFloat?, target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        self.midPoint = midPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
    }

    private var currentPoint: CGPoint?
    private var previousPoint: CGPoint?
    private var currentValue: CGFloat = 0
    private var rotation: CGFloat? {
        guard let currentPoint = currentPoint,
            let previousPoint = previousPoint else {
                return nil
        }

        var rotation = angleBetween(pointA: currentPoint, and: previousPoint)
        if rotation > .pi {
            rotation -= .pi * 2
        } else if rotation < -.pi {
            rotation += .pi * 2
        }
        print("rotation = \(rotation / (.pi * 2) * 100)")
        return rotation
    }

    private func distanceBetween(pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
        let x = CGFloat(pointA.x - pointB.x)
        let y = CGFloat(pointA.y - pointB.y)
        return CGFloat(sqrt(x * x + y * y))
    }

    private func angleFor(_ point: CGPoint) -> CGFloat {
        var angle = CGFloat(atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + .pi / 2

        if angle < 0 {
            angle += .pi * 2
        }
        print("angle = \(angle)")
        return angle
    }

    private func angleBetween(pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
        return angleFor(pointA) - angleFor(pointB)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print("touches began")
        guard let firstTouch = touches.first,
            let innerRadius = innerRadius,
            let distance = distance,
            let outerRadius = outerRadius else {
                return
        }

        currentPoint = firstTouch.location(in: view)

        if distance < innerRadius || distance > outerRadius {
            state = .failed
        }
    }

    override func reset() {
        super.reset()
        currentValue = 0
        currentPoint = nil
        previousPoint = nil
        print("reset")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        print("touches moved")
        guard state != .failed,
            let firstTouch = touches.first else {
                return
        }

        currentPoint = firstTouch.location(in: view)
        previousPoint = firstTouch.previousLocation(in: view)

        if let rotation = rotation {

            if let innerRadius = innerRadius,
                let outerRadius = outerRadius,
                let distance = distance {
                print("innerRadius = \(innerRadius) distance = \(distance) outerRadius = \(outerRadius)")
                if distance < innerRadius || distance > outerRadius {
                    state = .failed
                }
            }
            currentValue += rotation / (2 * .pi) * 100
            print(currentValue)
            if currentValue >= 100 || currentValue <= -100 {
                print("touch recognized")
                state = .recognized
            }
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }

}
