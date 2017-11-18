import Foundation
import UIKit.UIGestureRecognizerSubclass

final class ZLetterRecognizer: UIGestureRecognizer {
  
  let strokePrecision: CGFloat = 10
  var strokePart: UInt = 0
  var firstTap: CGPoint?
  
  override func reset() {
    super.reset()
    strokePart = 0
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>,
                             with event: UIEvent) {
    print("Touches Began")
    super.touchesBegan(touches, with: event)
    
    guard touches.count == 1 else {
      state = .failed
      return
    }
    
    firstTap = touches.first?.location(in: view?.superview)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    
    reset()
    print("touches ended")
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    
    guard state != .failed && state != .recognized else {
      return
    }
    
    guard let superview = view?.superview,
      let currentPoint = touches.first?.location(in: superview),
      let previousPoint = touches.first?.previousLocation(in: superview),
      let firstTap = firstTap else {
        return
    }
    
    if strokePart == 0 && currentPoint.x - firstTap.x > 160
      && currentPoint.x > previousPoint.x
      && currentPoint.y - firstTap.y <= strokePrecision {
      
      print("part 1 complete")
      strokePart = 1
      
    } else if strokePart == 1
      && currentPoint.x < previousPoint.x
      && currentPoint.y > previousPoint.y {
      
      strokePart = 2
      print("part 2 complete")
      
    } else if strokePart == 2
      && currentPoint.x > previousPoint.x
      && currentPoint.y - previousPoint.y <= strokePrecision {
      
      strokePart = 3
      state = .recognized
      print("zero recognized")
    }
  }
  
}

