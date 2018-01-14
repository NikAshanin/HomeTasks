import UIKit

final class GestureViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "circle.jpg")
        imageView.contentMode = .scaleAspectFit
        let oRecognizer = ORecognizer (midPoint: view.center, target: self, action: #selector(oRecognized))
        view.addGestureRecognizer(oRecognizer)
    }
    @objc func oRecognized() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "tabBar")
        present(homeViewController, animated: true, completion: nil)
    }
}
