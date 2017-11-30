import UIKit

final class GestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let oRecognizer = OLetterRecognizer(target: self, action: #selector(oRecognized))
        view.addGestureRecognizer(oRecognizer)
    }

    @objc func oRecognized() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
}
