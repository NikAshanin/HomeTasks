import UIKit

final class FilmTableViewCell: UITableViewCell {
    static let reuseId = "FilmTableViewCell"
    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    func configure(_ film: Film) {
        let imageName = "0\(film.photo)_film.jpg"
        filmImageView.image =  UIImage(named: imageName)
        nameLabel.text = film.name
        likeLabel.text = "\(film.likesCount)"
    }
    func update(_ value: String) {
        likeLabel.text = "\(value)"
        print(value)
    }
}
