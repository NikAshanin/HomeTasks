import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var plotLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var posterImage: UIImageView!
    var film: Film?
    weak var delegate: LikeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let film = film else {
            return
        }
        posterImage.image = film.posterImage
        nameLabel.text = film.name
        directorLabel.text = "Режиссер: " + film.director
        plotLabel.text = film.plot
        likeButton.setTitle(film.likeString, for: .normal)
    }

    @IBAction private func likeButtonPressed(_ sender: Any) {
        guard let film = film else {
            return
        }
        delegate?.like(film)
        likeButton.setTitle(film.likeString, for: .normal)
    }
}
