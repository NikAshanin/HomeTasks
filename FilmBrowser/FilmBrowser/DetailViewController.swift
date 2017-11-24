import UIKit

protocol LikeDelegate: class {
    func like(film: Film)
}
final class DetailViewController: UIViewController {

    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBAction private func likePressed(_ sender: UIButton) {
        guard let film = film else {
            return
        }
        sender.pulse()
        delegate?.like(film: film)
        likesLabel.text = "\(film.likes)"
    }

    static let storyboardID = "DetailViewController"
    var film: Film?
    weak var delegate: LikeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let film = film else {
            return
        }
        filmImageView.image = UIImage(named: film.image)
        descriptionLabel.text = film.description
        title = film.title
        likesLabel.text = "\(film.likes)"
    }
    deinit {
        print("deinited")
    }
}
