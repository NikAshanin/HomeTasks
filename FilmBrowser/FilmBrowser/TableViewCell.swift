import UIKit

class TableViewCell: UITableViewCell {
  @IBOutlet private weak var imageFilm: UIImageView!
  @IBOutlet private weak var countLikesLabel: UILabel!
  @IBOutlet private weak var titleFilmLabel: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  func pushDataToCell(_ film: Film) {
    imageFilm.image = UIImage(named: film.urlImage)
    countLikesLabel.text = String(film.countLikes)
    titleFilmLabel.text = film.name
  }
}
