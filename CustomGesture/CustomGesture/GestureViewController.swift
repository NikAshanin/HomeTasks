import UIKit

final class GestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let circleRecognizer = CircleGestureRecognizer(target: self,
                                                       action: #selector(circleTapPressed),
                                                       center: view.center,
                                                       radius: 110)
        view.addGestureRecognizer(circleRecognizer)
    }
    @objc private func circleTapPressed() {
        if let tabBar = storyboard?.instantiateViewController(withIdentifier: "tapBar") as? UITabBarController {
            present(tabBar, animated: true, completion: nil)
        }
    }
}
