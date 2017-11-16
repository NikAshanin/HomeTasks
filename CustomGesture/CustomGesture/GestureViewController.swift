import UIKit

final class GestureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(OLetterRecognizer(target: self, action: #selector(oLetterRecognized)))
    }
    @objc func oLetterRecognized() {
        guard let tabBar = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            else {
                return
        }
        tabBar.modalTransitionStyle = .crossDissolve
        present(tabBar, animated: true)
    }

}
