import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak private var filmImageView: UIImageView!
    @IBOutlet weak private var textInfoLabel: UILabel!
    @IBOutlet weak private var likeBtn: UIButton!
    weak var delegate: LikeChangeProtocol?
    var film: Film?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let film = film else {
            return
        }
        filmImageView.image = UIImage(named: "\(film.imageName).jpg")
        textInfoLabel.text = film.descriptionFilm
        title = film.name
        likeBtnUpdate(film: film)
    }

    @IBAction func submit(_ sender: Any) {
        guard let film = film else {
            return
        }
        delegate?.likeChange(film: film)
        likeBtnUpdate(film: film)
    }

    private func likeBtnUpdate(film: Film) {
        likeBtn.setTitle("Like: \(film.likeCount)", for: .normal)
    }
}
protocol LikeChangeProtocol: class {
    func likeChange(film: Film)
}
