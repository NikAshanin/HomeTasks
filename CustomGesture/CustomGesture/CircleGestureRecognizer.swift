import UIKit
import UIKit.UIGestureRecognizerSubclass

extension CGFloat {
  var degrees:CGFloat {
    return self * 180 / .pi;
  }
  var radians:CGFloat {
    return self * .pi / 180;
  }
  var rad2deg:CGFloat {
    return self.degrees
  }
  var deg2rad:CGFloat {
    return self.radians
  }
  
}

class CircleGestureRecognizer: UIGestureRecognizer {

  var currentPoint:CGPoint?
  var previousPoint:CGPoint?
  var midPoint = CGPoint.zero
  var innerRadius:CGFloat?
  var outerRadius:CGFloat?
  
  var rotation:CGFloat? {
    if let currentPoint = self.currentPoint {
      if let previousPoint = self.previousPoint {
        var rotation = angleBetween(pointA: currentPoint, andPointB: previousPoint)
        if rotation > .pi {
          rotation -= .pi*2
        } else if (rotation < -.pi) {
          rotation += .pi*2
        }
        return rotation
      }
    }
    return nil
  }
  
  var angle:CGFloat? {
    if let nowPoint = self.currentPoint {
      return self.angleForPoint(point: nowPoint)
    }
    return nil
  }
  
  var distance:CGFloat? {
    if let nowPoint = self.currentPoint {
      return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
    }

    return nil
  }
  
  init(midPoint:CGPoint, innerRadius:CGFloat?, outerRadius:CGFloat?, target:AnyObject?, action:Selector) {
    super.init(target: target, action: action)
    self.midPoint = midPoint
    self.innerRadius = innerRadius
    self.outerRadius = outerRadius
  }
  
  convenience init(midPoint:CGPoint, target:AnyObject?, action:Selector) {
    self.init(midPoint:midPoint, innerRadius:nil, outerRadius:nil, target:target, action:action)
  }

  func distanceBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
    let dx = Float(pointA.x - pointB.x)
    let dy = Float(pointA.y - pointB.y)
    return CGFloat(sqrtf(dx*dx + dy*dy))
  }
  
  func angleForPoint(point:CGPoint) -> CGFloat {
    var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + .pi/2
    if angle < 0 {
      angle += .pi*2;
    }
    return angle
  }
  
  func angleBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
    return angleForPoint(point: pointA) - angleForPoint(point: pointB)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    if let firstTouch = touches.first {
      currentPoint = firstTouch.location(in: self.view)
      var newState:UIGestureRecognizerState = .began
      if let innerRadius = self.innerRadius, let distance = self.distance {
        if distance < innerRadius {
          newState = .failed
        }
      }
      if let outerRadius = self.outerRadius, let distance = self.distance {
        if distance > outerRadius {
          newState = .failed
        }
      }
      state = newState
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    if state == .failed {
      return
    }
    if let firstTouch = touches.first {
      currentPoint = firstTouch.location(in: self.view)
      previousPoint = firstTouch.previousLocation(in: self.view)
      state = .changed
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    state = .ended
    currentPoint = nil
    previousPoint = nil
  }
  
}
