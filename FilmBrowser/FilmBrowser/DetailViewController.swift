import UIKit

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
    countLikesLabel.text = "Всего лайков:\(String(film.countLikes))"
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    descriptionLabel.text = film.description
    imageFilm.image = UIImage(named: film.urlImage)
    nameOfFilmLabel.text = film.name
    countLikesLabel.text = "Всего лайков:\(String(film.countLikes))"
  }
}

protocol LikeChangeProtocol: class {
  func likeChange(_ index: Int)
}
