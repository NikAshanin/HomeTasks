import UIKit

final class FilmTableViewCell: UITableViewCell {

    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!

    static let reuseId = "FilmTableViewCell"

    func configure(_ film: Film) {
        titleLabel.text = film.title
        likesLabel.text = "Likes: \(film.likes)"
        filmImageView.image = UIImage(named: film.image)
    }
}
