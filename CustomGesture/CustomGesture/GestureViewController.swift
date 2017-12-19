import UIKit

final class GestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let oRecognizer = OLetterRecognizer(target: self, action: #selector(oRecognized))
        view.addGestureRecognizer(oRecognizer)
    }

    @objc private func oRecognized() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
}
