import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var likesButton: UIButton!

    var film: Film?
    weak var delegate: LikesProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let film = film else {
            return
        }
        posterImageView.image = UIImage(named: film.image)
        descriptionLabel.text = film.description
        title = film.title
        updateLikesButton(film: film)
    }

    @IBAction func touchLike(_ sender: UIButton) {
        guard let film = film else {
            return
        }
        delegate?.addLike(film: film)
        updateLikesButton(film: film)
    }

    private func updateLikesButton(film: Film) {
        likesButton.setTitle("(\(film.likes)): Like", for: .normal)
    }

}

protocol LikesProtocol: class {
    func addLike(film: Film)
}
