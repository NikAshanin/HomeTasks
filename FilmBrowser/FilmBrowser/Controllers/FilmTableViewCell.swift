import UIKit

final class FilmTableViewCell: UICollectionViewCell {

    @IBOutlet private weak var filmName: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var filmImage: UIImageView!
    @IBOutlet private weak var likeImage: UIImageView!

     func setFilmInfo(_ film: Film) {
        filmName.text = film.name
        likesCount.text = String(film.likesCount)
        filmImage.image = film.image
        selectImageForLikeState(film)
    }

     private func selectImageForLikeState(_ film: Film) {
        let resourceName = film.liked ? "liked" : "like"
        likeImage.image = (#imageLiteral(resourceName: resourceName))
    }
}
