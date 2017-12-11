import UIKit

final class FilmTableViewCell: UITableViewCell {
    static let reuseId = "FilmTableViewCell"

    @IBOutlet weak private var filmTitleLabel: UILabel!
    @IBOutlet weak private var filmImage: UIImageView!
    @IBOutlet weak private var filmLikesLabel: UILabel!

    func configure(_ film: Film) {
        let imageName = film.image
        filmImage.image = UIImage(named: imageName)
        filmTitleLabel.text = film.title
        filmLikesLabel.text = "Likes: " + String(film.likes)
    }
}
