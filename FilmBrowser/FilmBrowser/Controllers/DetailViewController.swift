import UIKit

final class DetailViewController: UIViewController {
    var film = Film(title: "", image: "", likesCount: 0, descrip: "")
    var likes = 0

    @IBOutlet weak private var filmLabel: UILabel!
    @IBOutlet weak private var filmImage: UIImageView!
    @IBOutlet weak private var filmDescrip: UILabel!
    @IBOutlet weak private var likeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = UIImage(named: film.image) else {
            return
        }

        filmLabel.text = film.title
        filmImage.image = image
        filmDescrip.text = film.descrip
        likeButton.setTitle("\(likes) likes", for: .normal)
    }

    weak var delegate: LikeDelegate?

    @IBAction func likeButtonTapped(_ sender: Any) {
        likes += 1
        delegate?.plusOneLike(to: film.title)
        likeButton.setTitle("\(likes) likes", for: .normal)
    }
}
