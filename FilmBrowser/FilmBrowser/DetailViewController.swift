import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!

    weak var delegate: DetailViewProtocol?

    var film: Film?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func likePressed(_ sender: UIButton) {
        guard let film = film else {
            return
        }

        film.likes += 1
        UIView.transition(with: sender,
                          duration: 0.2,
                          options: .transitionFlipFromLeft,
                          animations: nil,
                          completion: { [weak self] _ in
                            self?.likesLabel?.text = String(describing: film.likes) })

        delegate?.buttonPressed(film)
    }

    private func updateUI() {
        guard let film = film else {
            return
        }
        posterImageView?.image = UIImage(named: film.poster)
        titleLabel?.text = film.title
        descriptionLabel?.text = film.description
        likesLabel?.text = String(describing: film.likes)
        title = film.title
    }
}
