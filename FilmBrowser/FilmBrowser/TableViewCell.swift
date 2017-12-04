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

    public func setImage(image: UIImage?) {
        guard image != nil else {
            return
        }
       imageFilm.image = image
    }

    public func setFilmTitle(title: String) {
        titleFilmLabel.text = title
    }

    public func setLikesCount(likes: Int) {
        countLikesLabel.text = String(likes)
    }
}
