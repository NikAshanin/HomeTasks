import UIKit

final class FilmTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var likeLable: UILabel!
    static let cellIdentifier = "cell"
    func configure(film: Film) {
        logoImageView.image = UIImage(named: "\(film.imageName).jpg")
        textView.text = film.name
        likeLable.text = "Like: \(film.likeCount)"
    }
}
