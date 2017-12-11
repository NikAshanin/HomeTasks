import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak private var poster: UIImageView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var likesButton: UIButton!

    var film: Film?
    weak var delegate: LikesProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.addSubview(descriptionLabel)
        guard let film = film else {
            return
        }
        poster.image = UIImage(named: film.image)
        descriptionLabel.text = film.description
        title = film.title
        likesButton.setTitle("(\(film.likes)): Like", for: .normal)
    }

    @IBAction func touchLike(_ sender: UIButton) {
        guard let film = film else {
            return
        }
        delegate?.addLike(film: film)
        likesButton.setTitle("(\(film.likes)): Like", for: .normal)
    }

}

protocol LikesProtocol: class {
    func addLike(film: Film)
}
