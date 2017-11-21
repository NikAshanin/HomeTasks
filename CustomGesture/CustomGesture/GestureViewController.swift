import UIKit

final class GestureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let CircleRecognizer = UICircleGestureRecognizer(target: self,
                                                         action: #selector(circleRecognized))
        view.addGestureRecognizer(CircleRecognizer)
    }

    @objc private func circleRecognized() {
        let alert = UIAlertController(title: "Circle recognized", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil
//        { [weak self] _ in
//            self?.performSegue(withIdentifier: "TapBar", sender: nil)
//        }
        ))
        present(alert, animated: true, completion: nil)
    }

}
