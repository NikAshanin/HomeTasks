import UIKit

final class FilmTableViewCell: UITableViewCell {
    static let reuseId = "FilmTableViewCell"
    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    
    func configure(_ film: Film) {
        filmImageView.image =  UIImage(named: film.photo)
        nameLabel.text = film.name
        likeLabel.text = "\(film.likesCount)"
    }
    
    func update(_ value: String) {
        likeLabel.text = "\(value)"
        print(value)
    }
}
