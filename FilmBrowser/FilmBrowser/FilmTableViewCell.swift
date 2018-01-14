import UIKit

final class FilmTableViewCell: UITableViewCell {
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var textView: UILabel!
    @IBOutlet weak private var likeLable: UILabel!
    static let cellIdentifier = "cell"

    func configure(film: Film) {
        logoImageView.image = UIImage(named: "\(film.imageName).jpg")
        textView.text = film.name
        likeLable.text = "Like: \(film.likeCount)"
    }
}
