import UIKit

final class GestureViewController: UIViewController {

    @IBOutlet weak private var circleImageView: UIImageView!

    private var innerRadius: CGFloat {
        return circleImageView.frame.width / 3
    }
    private var outerRadius: CGFloat {
        return circleImageView.frame.width / 2
    }
    private var center: CGPoint {
        return circleImageView.center
    }
    private var currentValue: CGFloat = 0.0 {
        didSet {
            if currentValue > 100 {
                currentValue = 100
            }
            if currentValue < 0 {
                currentValue = 0
            }
        }
    }
    private var circleRecognizer: CircleGestureRecognizer {
        return CircleGestureRecognizer(midPoint: center,
                                       innerRadius: innerRadius,
                                       outerRadius: outerRadius,
                                       target: self,
                                       action: #selector(circleGesture))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        print(circleImageView.frame.size.width)
        view.addGestureRecognizer(circleRecognizer)
    }

    @objc func circleGesture(recognizer: CircleGestureRecognizer) {
        if recognizer.rotationAngle == nil {
            currentValue = 0
        }

        if let rotation = recognizer.rotationAngle {
            currentValue += rotation.degrees / 360 * 100
            print("value: \(currentValue)")
        }

        if currentValue == 100.0 {
            performSegue(withIdentifier: "Show Tab Bar", sender: self)
            currentValue = 0
        }
    }
}
