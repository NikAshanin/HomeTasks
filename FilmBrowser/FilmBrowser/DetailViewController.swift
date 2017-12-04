import UIKit

protocol LikeChangeProtocol: class {
    func likeChange(_ index: Int)
}

class DetailViewController: UIViewController {

  @IBOutlet private weak var imageFilm: UIImageView!
  @IBOutlet private weak var button: UIButton!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var countLikesLabel: UILabel!
  @IBOutlet private weak var nameOfFilmLabel: UILabel!

  weak var delegate: LikeChangeProtocol?
  var film = Film()
  var currentIndex = Int()

  @IBAction func submit(_ sender: Any) {
    film.countLikes += 1
    delegate?.likeChange(currentIndex)
    countLikesLabel.text = "Likes :\(String(film.countLikes))"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    descriptionLabel.text = film.description
    countLikesLabel.text = "Likes :\(String(film.countLikes))"
    nameOfFilmLabel.text = film.name
    imageFilm.image = UIImage(named: film.urlImage)
  }
}
