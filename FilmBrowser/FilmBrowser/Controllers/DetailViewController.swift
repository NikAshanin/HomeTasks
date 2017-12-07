import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    @IBOutlet private weak var likedButton: UIButton!
    @IBOutlet private weak var filmDescriptionLabel: UILabel!
    @IBOutlet private weak var likesCountLabel: UILabel!
    var film: Film?
    weak var delegate: LikeCountChanged?

    override func viewDidLoad() {
        super.viewDidLoad()
        showFilmDetailInfo()
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        guard let film  = film else {
            return }
        if film.liked {
            film.removeLike()
        } else {
            film.addLike()
        }
        updateLikeStatus()
        likesCountLabel.text = String(film.likesCount)
        delegate?.likeButtonPressed(film)
    }

    func showFilmDetailInfo() {
        guard let film = film else {
            return
        }
        filmImageView.image = film.image
        filmNameLabel.text = film.name
        filmDescriptionLabel.text = film.description
        likesCountLabel.text = String(film.likesCount)
        updateLikeStatus()
    }

    func updateLikeStatus() {
        guard let film = film else {
            return
        }
        let resourceName = film.liked ? "liked" : "like"
        likedButton.setBackgroundImage(#imageLiteral(resourceName: resourceName), for: .normal)
    }
}
