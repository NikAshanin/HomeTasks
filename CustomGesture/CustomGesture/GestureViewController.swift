import UIKit

final class GestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let circleRecognizer = UICircleGestureRecognizer(target: self,
                                                         action: #selector(circleRecognized))
        view.addGestureRecognizer(circleRecognizer)
    }

    @objc private func circleRecognized() {
        let alert = UIAlertController(title: "Circle recognized", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.performSegue(withIdentifier: "tabbar", sender: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
