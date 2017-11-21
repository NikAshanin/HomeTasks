import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let circleRecognizer = CircleRecognizer(target: self, action: #selector(self.circleTapPressed))
        circleRecognizer.setCircle(center: self.view.center, radius: 120)
        self.view.addGestureRecognizer(circleRecognizer)
    }
    @objc func circleTapPressed() {
        if let tabBar = storyboard?.instantiateViewController( withIdentifier: "testController" ) as? UITabBarController {
            self.present(tabBar, animated: true, completion: nil)
        }
    }
}
