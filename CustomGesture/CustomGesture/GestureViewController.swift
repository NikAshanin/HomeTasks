import UIKit

final class GestureViewController: UIViewController {
    @IBOutlet private weak var circle: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let circleWidth = circle.frame.size.width/2
        let circleHeight = circle.frame.size.height/2
        var circleCenter = circle.frame.origin
        circleCenter.x += circleWidth
        circleCenter.y += circleHeight
        let oRecognizer = OGestureRecognizer(width: circleWidth,
                                             height: circleHeight,
                                             center: circleCenter,
                                             target: self,
                                             action: #selector(oRecognized))

        view.addGestureRecognizer(oRecognizer)
    }

    @objc private func oRecognized() {
        if let tabBar = storyboard?.instantiateViewController(withIdentifier: "tabBar") {
                navigationController?.pushViewController(tabBar, animated: true)
        }
    }
}
