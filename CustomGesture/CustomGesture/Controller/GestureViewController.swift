import UIKit

final class GestureViewController: UIViewController {

    @IBOutlet weak private var circleImageView: UIImageView!

    private var innerRadius: CGFloat {
        return view.frame.width / 3
    }
    private var outerRadius: CGFloat {
        return view.frame.width / 2
    }
    private var center: CGPoint {
        return view.center
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print(view.frame.width)
        let circleRecognizer = CircleGestureRecognizer(midPoint: center,
                                                       innerRadius: innerRadius,
                                                       outerRadius: outerRadius,
                                                       target: self,
                                                       action: #selector(circleGesture))

        view.addGestureRecognizer(circleRecognizer)
    }

    @objc private func circleGesture() {
            performSegue(withIdentifier: "Show Tab Bar", sender: self)
    }
}
