import UIKit

final class FilmTableViewCell: UITableViewCell {

    static let reuseId = "FilmTableViewCell"

    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var filmTitleLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!

    func updateUI(film: Film) {
        filmImageView.image = UIImage(named: film.imageName)
        filmTitleLabel.text = film.title
        likesLabel.text = "Likes: " + String(film.getLikes())
    }
}
