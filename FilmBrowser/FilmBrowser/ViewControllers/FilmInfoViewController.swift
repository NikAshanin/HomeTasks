import UIKit

final class FilmInfoViewController: UIViewController {

    static let storyboardId = "FilmInfoViewController"

    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var filmTitleLabel: UILabel!
    @IBOutlet private weak var filmDescriptionLabel: UILabel!
    @IBOutlet private weak var likesButton: UIButton!

    var film: Film?
    weak var likeDelegate: LikeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Film info"
        guard let film = film else {
            return
        }
        filmImageView.image = UIImage(named: film.imageName)
        filmDescriptionLabel.text = film.description
        filmTitleLabel.text = film.title
        reloadButtonTitle()
    }

    private func reloadButtonTitle() {
        guard let film = film else {
            return
        }
        likesButton.setTitle(String(describing: film.getLikes), for: .normal)
    }

    @IBAction private func likesButtonPressed(_ sender: UIButton) {
        film?.addLike()
        reloadButtonTitle()
        likeDelegate?.like()
    }
}

protocol LikeDelegate: class {
    func like()
}
