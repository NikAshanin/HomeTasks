import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var filmImage: UIImageView!
    @IBOutlet private weak var filmName: UILabel!
    @IBOutlet private weak var liked: UIButton!
    @IBOutlet private weak var filmDescription: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
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
        likesCount.text = String(film.likesCount)
        delegate?.likeButtonPressed(film)
    }

    func showFilmDetailInfo() {
        guard let film = film else {
            return
        }
        filmImage.image = film.image
        filmName.text = film.name
        filmDescription.text = film.description
        filmDescription.sizeToFitOnlyHeight(maxWidth: filmDescription.frame.width)
        likesCount.text = String(film.likesCount)
        updateLikeStatus()
    }

    func updateLikeStatus() {
        guard let film = film else {
            return
        }
        let resourceName = film.liked ? "liked" : "like"
        liked.setBackgroundImage(#imageLiteral(resourceName: resourceName), for: .normal)
    }
}
