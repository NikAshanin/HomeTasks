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

    var filmData: Film? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        posterImageView.image = filmData?.poster
        titleLabel.text = filmData?.title
        descriptionLabel.text = filmData?.descr
        likesLabel.text = String(describing: filmData?.likes ?? 0)
    }
}
