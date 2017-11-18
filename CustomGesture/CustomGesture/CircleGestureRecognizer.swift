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

    // Distance between touch and middle point
    private var distance: CGFloat? {

        if let newPoint = currentPoint {
            return distanceBetween(pointA: midPoint, and: newPoint)
        }
        return nil
    }

    init(midPoint: CGPoint, innerRadius: CGFloat?, outerRadius: CGFloat?, target: AnyObject?, action: Selector) {
        self.midPoint = midPoint
        super.init(target: target, action: action)
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
        let rotation = angleBetween(pointA: currentPoint, and: previousPoint)
        print("rotation = \(rotation / (.pi * 2) * 100)")
        return rotation
    }

    private func distanceBetween(pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
        let x = CGFloat(pointA.x - pointB.x)
        let y = CGFloat(pointA.y - pointB.y)
        return CGFloat(sqrt(x * x + y * y))
    }

    private func angle(for point: CGPoint) -> CGFloat {
        let angle = atan2(point.x - midPoint.x, point.y - midPoint.y) + .pi / 2
        print("angle = \(angle)")
        return angle
    }

    private func angleBetween(pointA: CGPoint, and pointB: CGPoint) -> CGFloat {
        var angle = self.angle(for: pointA) - self.angle(for: pointB)
        if angle > .pi {
            angle -= .pi * 2
        } else if angle < -.pi {
            angle += .pi * 2
        }
        return angle
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

        guard let rotation = rotation else {
            return
        }
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        reset()
    }

}
