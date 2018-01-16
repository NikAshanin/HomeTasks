import UIKit

final class GestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let oRecognizer = ORecognizer(target: self,
                                      action: #selector(ORecognized))
        view.addGestureRecognizer(oRecognizer)
    }

    @objc private func ORecognized() {
        performSegue(withIdentifier: "goToTabBarController", sender: self)
    }
}
