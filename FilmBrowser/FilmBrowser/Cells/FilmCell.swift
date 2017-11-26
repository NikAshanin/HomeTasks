import UIKit

final class FilmCell: UITableViewCell {

    static let reuseId = "FilmCell"

    @IBOutlet weak private var filmTitle: UILabel!
    @IBOutlet weak private var filmImage: UIImageView!
    @IBOutlet weak private var likeLabel: UILabel!

    func configure(_ film: Film, likes: Int) {
        let imageName = film.image
        filmImage.image = UIImage(named: imageName)
        filmTitle.text = film.title
        likeLabel.text = "\(likes) likes"
    }
}
