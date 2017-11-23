import UIKit

class ViewController: UIViewController {
  
  var circleRecognizer: CircleGestureRecognizer!
  var currentCircle : CGFloat = 100
  var currentValue:CGFloat = 0.0 {
    didSet {
      if (currentValue > 100) {
        currentValue = 100
      }
      if (currentValue < 0) {
        currentValue = 0
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let cgr = CircleGestureRecognizer(midPoint: self.view.center, innerRadius:currentCircle - 25, outerRadius:self.currentCircle, target: self, action: #selector(circled))
    view.addGestureRecognizer(cgr)
  }
  
  
  @objc func circled(recognizer: CircleGestureRecognizer) {
    
    if let rotation = recognizer.rotation {
      currentValue += rotation.degrees / 360 * 100
      print(currentValue)
    }
    if let dist = recognizer.distance {
      if currentValue == 100 && dist <= currentCircle {
        if let tabBar = storyboard?.instantiateViewController(withIdentifier: "123") as? TabBarController {
          self.present(tabBar, animated: true, completion: nil)
        }
      }
    }
  }

}
