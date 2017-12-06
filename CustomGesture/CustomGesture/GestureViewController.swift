import UIKit

final class GestureViewController: UIViewController {
    @IBOutlet private weak var circle: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let circleWidth = circle.frame.size.width/2
        let circleHeigh = circle.frame.size.height/2
        var circleCenter = circle.frame.origin
        circleCenter.x += circleWidth
        circleCenter.y += circleHeigh
        let oRecognizer = OGestureRecognizer(width: circleWidth,
                                             heigh: circleHeigh,
                                             center: circleCenter,
                                             target: self,
                                             action: #selector(oRecognized))
        view.addGestureRecognizer(oRecognizer)
    }
    @objc func oRecognized() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sec = storyBoard.instantiateViewController(withIdentifier: "tabBar") as? TabBarViewController else {
            return
        }
        self.present(sec, animated: true, completion: nil)
    }
}
