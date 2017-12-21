import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var filmLabel: UILabel!
    @IBOutlet private weak var filmDescriptionLabel: UILabel!
    weak var delegate: LikesChangeProtocol?
    var currentFilm: Film?
    var filmDiscription: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadFilmData()
    }

    @IBAction private func submitLike(_ sender: Any) {
        currentFilm?.likesCount += 1
        guard let likesCount = currentFilm?.likesCount else {
            return
        }
        setButtonTitle(with: likesCount)
        delegate?.likesChange()
    }

    private func downloadFilmData() {
        guard let likesCount =  currentFilm?.likesCount,
            let photoName = currentFilm?.photo,
            let filmTitle = currentFilm?.name  else {
            return
        }
        setButtonTitle(with: likesCount)
        filmImageView.image =  UIImage(named: photoName)
        filmLabel.text = filmTitle
        filmDescriptionLabel.text = filmDiscription
    }

    private func setButtonTitle(with amountOfLikes: Int) {
        likeButton.setTitle(String(amountOfLikes), for: UIControlState.normal)
    }
}

protocol LikesChangeProtocol: class {
    func likesChange()
}
