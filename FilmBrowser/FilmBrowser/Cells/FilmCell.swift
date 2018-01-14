import UIKit

final class FilmCell: UITableViewCell {

    static let reuseId = "FilmCell"

    @IBOutlet weak private var filmTitleLabel: UILabel!
    @IBOutlet weak private var filmImageView: UIImageView!
    @IBOutlet weak private var likeLabel: UILabel!

    func configure(_ film: Film) {
        let imageName = film.image
        filmImageView.image = UIImage(named: imageName)
        filmTitleLabel.text = film.title
        likeLabel.text = "\(film.likesCount) likes"
    }
}
