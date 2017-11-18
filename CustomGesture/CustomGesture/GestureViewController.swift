import UIKit

final class GestureViewController: UIViewController {

    let identifier = "TabBarController"

    @IBOutlet private weak var circleView: CircleView! {
        didSet {
            let center = CGPoint(x: circleView.bounds.width / 2, y: circleView.bounds.height / 2)
            let innerRadius = circleView.bounds.width / 2 - circleView.lineWidth
            let circleGestureRecognizer = CircleGestureRecognizer(midPoint: center,
                                                                  innerRadius: innerRadius,
                                                                  outerRadius: circleView.bounds.width / 2,
                                                                  target: self,
                                                                  action: #selector(circle))
            circleView.addGestureRecognizer(circleGestureRecognizer)
        }
    }

    @objc private func circle() {
        guard let tabBar = storyboard?.instantiateViewController(withIdentifier: identifier) as? UITabBarController else {
            return
        }
        present(tabBar, animated: true)
    }
}
