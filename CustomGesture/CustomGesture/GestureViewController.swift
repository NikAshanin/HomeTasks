import UIKit

final class GestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let circleRecognizer = CircleRecognizer(target: self, action: #selector(circleTapPressed),
                                                center: view.center, radius: 120)
        view.addGestureRecognizer(circleRecognizer)
    }
    @objc private func circleTapPressed() {
        if let tabBar = storyboard?.instantiateViewController(withIdentifier: "testController") as? UITabBarController {
            present(tabBar, animated: true, completion: nil)
        }
    }
}
