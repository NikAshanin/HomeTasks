import UIKit

final class GestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(OLetterRecognizer(target: self, action: #selector(oLetterRecognized)))
    }
    @objc private func oLetterRecognized() {
        guard let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            else {
                return
        }
        tabBar.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(tabBar, animated: true)
    }
}
