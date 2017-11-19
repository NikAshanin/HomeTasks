import UIKit

final class GestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let oRecognizer = ORecognizer(target: self,
                                      action: #selector(ORecognized))
        view.addGestureRecognizer(oRecognizer)
    }
    @objc func ORecognized() {
        self.performSegue(withIdentifier: "goToTabBarController", sender: self)
    }
}
