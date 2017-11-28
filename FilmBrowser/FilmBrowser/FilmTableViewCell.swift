import UIKit

final class FilmTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!

    var film: Film? {
        didSet {
            updateUI(filmData: film)
        }
    }

    func updateUI(filmData: Film?) {
        guard let filmData = filmData else {
            return
        }
        posterImageView.image = UIImage(named: filmData.poster)
        titleLabel.text = filmData.title
        descriptionLabel.text = filmData.description
        likesLabel.text = String(describing: filmData.likes)
    }
}
