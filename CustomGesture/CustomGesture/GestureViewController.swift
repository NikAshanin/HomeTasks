import UIKit

final class GestureViewController: UIViewController {

    @IBOutlet weak private var circleView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = "Circle.png"
        let image = UIImage(named: imageName)
        circleView.image = image
        let oRecognizer = OLetterRecognizer(target: self, action: #selector(oRecognized))
        view.addGestureRecognizer(oRecognizer)
    }

    @objc func oRecognized() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
}
