import UIKit

final class FilmTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var likeLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(film: FilmObject) {
        logoImageView.image = UIImage(named: "\(film.imageName).jpg")
        textView.text = film.filmName
        likeLable.text = "Like: \(film.likeCount)"
    }
}
