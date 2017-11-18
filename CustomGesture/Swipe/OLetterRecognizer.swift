import UIKit.UIGestureRecognizerSubclass
import Foundation


class _LetterRecognizer: UIGestureRecognizer {
  
  let strokePrecision: CGFloat = 10
  var strokePart: UInt = 0
    var firstTap: CGPoint?
  var currentAngle: CGFloat = 0
  var previousAngle: CGFloat = 0
  var target: Any?
  var action: Any?

  override func reset() {
    super.reset()
    strokePart = 0
  }
  
  override init(target: Any?, action: Selector?) {
        self.action = action
        self.target = target
    super.init(target: target, action: action)
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
    
    self.currentAngle = getTouchAngle(touch: (touches.first?.location(in: view?.superview))!)
    self.previousAngle = getTouchAngle(touch: (touches.first?.preciseLocation(in: view?.superview))!)
    
  }
  
  func getTouchAngle(touch: CGPoint) -> CGFloat {
    
    let x = touch.x - 160
    let y = -(touch.y - 160)
    
    if y == 0 {
      if x > 0 {
        return CGFloat.pi
      } else {
        return 3 * CGFloat.pi
      }
    }
    
    let arctan = atan(x/y)
    
    if x >= 0 && y > 0 {
      return (arctan)
    }
    else if x < 0 && y > 0 {
      return arctan + 2 * .pi
    }
    
    else if x <= 0 && y < 0 {
      return arctan + .pi
    }
    
    else if x > 0 && y < 0{
      return arctan + .pi
    }
    
    return -1
  }
  
}

