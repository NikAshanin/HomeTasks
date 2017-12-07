import UIKit

final class DetailViewController: UIViewController {
    var film: Film!

    @IBOutlet weak private var filmLabel: UILabel!
    @IBOutlet weak private var filmImage: UIImageView!
    @IBOutlet weak private var filmDescrip: UILabel!
    @IBOutlet weak private var likeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let film = film, let image = UIImage(named: film.image) else {
            return
        }

        filmLabel.text = film.title
        filmImage.image = image
        filmDescrip.text = film.description
        likeButton.setTitle("\(film.likesCount) likes", for: .normal)
    }

    weak var delegate: LikeDelegate?

    @IBAction func likeButtonTapped(_ sender: Any) {
        delegate?.plusOneLike(toFilm: film)
        likeButton.setTitle("\(film.likesCount) likes", for: .normal)
    }
}
