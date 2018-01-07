import UIKit

final class FilmTableViewCell: UITableViewCell {
    static let reuseId = "FilmTableViewCell"

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ film: Film) {
        posterImageView.image = film.posterImage
        nameLabel.text = film.name
        directorLabel.text = film.director
        likeLabel.text = film.likeString
    }
}
