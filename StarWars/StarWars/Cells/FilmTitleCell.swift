import UIKit

final class FilmTitleCell: UITableViewCell {

    static let reuseId = "FilmTitleCell"

    @IBOutlet weak private var filmTitle: UILabel!

    func configure(_ film: FilmsModel) {

        filmTitle.text = film.title
    }
}
