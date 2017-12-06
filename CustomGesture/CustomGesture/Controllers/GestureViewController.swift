import UIKit

final class GestureViewController: UIViewController {

    @IBOutlet private weak var circleView: CircleView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let circleGestureRecognizer = CircleGestureRecognizer(circleView: circleView,
                                                              target: self,
                                                              action: #selector(presentTabBarController))
        print(circleView.center)
        print()
        print(view.center)
        circleView.addGestureRecognizer(circleGestureRecognizer)
    }

    @objc private func presentTabBarController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as? UITabBarController
        guard let customTabBarController = controller else {
            return
        }
        present(customTabBarController, animated: true)
    }
}
