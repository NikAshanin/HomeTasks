import UIKit

final class FilmTableCell: UITableViewCell {

    @IBOutlet private weak var filmLogo: UIImageView!
    @IBOutlet private weak var filmName: UILabel!
    @IBOutlet private weak var likesCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ cellViewModel: FilmCellViewModel) {

        guard let logo = cellViewModel.filmLogo,
            let name = cellViewModel.filmName,
            let likes = cellViewModel.likesCount
            else { return }

        filmLogo.image = UIImage(named: logo)
        filmName.text = name
        likesCount.text = String(likes)

    }
}
