import UIKit

class TableViewCell: UITableViewCell {
  @IBOutlet  weak var imageFilm: UIImageView!
  @IBOutlet  weak var countLikesLabel: UILabel!
  @IBOutlet  weak var titleFilmLabel: UILabel!

  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
