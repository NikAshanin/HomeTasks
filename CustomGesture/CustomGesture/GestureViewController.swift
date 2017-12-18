import UIKit

final class GestureViewController: UIViewController {

    @IBOutlet weak private var circleView: UIImageView!
    private var oRecognozerClass = OLetterRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageName = "Circle.png"
        let image = UIImage(named: imageName)
        circleView.image = image
        let cRecognizer = OLetterRecognizer(target: self, action: #selector(self.cRecognized))
        view.addGestureRecognizer(cRecognizer)
    }

    @objc func cRecognized() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
}
