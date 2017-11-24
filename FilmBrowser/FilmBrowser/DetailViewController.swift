import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!

    weak var delegate: DetailViewProtocol?

    var film: Film?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func likePressed(_ sender: UIButton) {
        guard let film = film, let index = index else {
            return
        }
        film.likes += 1
        likesLabel?.text = String(describing: film.likes)
        delegate?.buttonPressed(index)
    }

    private func updateUI() {
        guard let film = film else {
            return
        }
        posterImageView?.image = film.poster
        titleLabel?.text = film.title
        descriptionLabel?.text = film.descr
        likesLabel?.text = String(describing: film.likes)
        self.title = film.title
    }

}
