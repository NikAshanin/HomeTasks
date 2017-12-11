import UIKit

final class FilmTableViewCell: UITableViewCell {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var likeImage: UIImageView!

    var film: Film? {
        didSet {
            updateUI(filmData: film)
        }
    }

    private func updateUI(filmData: Film?) {
        guard let filmData = filmData else {
            return
        }
        posterImageView?.image = UIImage(named: filmData.poster)
        titleLabel?.text = filmData.title
        descriptionLabel?.text = filmData.description
        likesLabel?.text = String(describing: filmData.likes)
        likeImage.image = #imageLiteral(resourceName: "likeRed.png")
    }
}
