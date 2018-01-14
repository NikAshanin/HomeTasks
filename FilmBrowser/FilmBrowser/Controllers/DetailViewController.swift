import UIKit

final class DetailViewController: UIViewController {
    var film: Film!

    @IBOutlet weak private var filmLabel: UILabel!
    @IBOutlet weak private var filmImageView: UIImageView!
    @IBOutlet weak private var filmDescriptionLabel: UILabel!
    @IBOutlet weak private var likeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let film = film, let image = UIImage(named: film.image) else {
            return
        }

        filmLabel.text = film.title
        filmImageView.image = image
        filmDescriptionLabel.text = film.description
        likeButton.setTitle("\(film.likesCount) likes", for: .normal)
    }

    weak var delegate: LikeDelegate?

    @IBAction private func likeButtonTapped(_ sender: Any) {
        delegate?.plusOneLike(toFilm: film)
        likeButton.setTitle("\(film.likesCount) likes", for: .normal)
    }
}
