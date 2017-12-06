import UIKit

final class FilmTableViewCell: UICollectionViewCell {

    @IBOutlet private weak var filmName: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var filmImage: UIImageView!
    @IBOutlet private weak var likeImage: UIImageView!

    public func setFilmInfo(_ film: Film) {
        filmName.text = film.name
        filmName.sizeToFitOnlyHeight(maxWidth: filmName.frame.width)
        likesCount.text = String(film.likesCount)
        filmImage.image = film.image
        selectImageForLikeState(film)
    }

    public func selectImageForLikeState(_ film: Film) {
        if film.liked {
            likeImage.image = #imageLiteral(resourceName: "liked")
        } else {
            likeImage.image = #imageLiteral(resourceName: "like")
        }
        let resourceName = film.liked ? "liked" : "like"
        likeImage.image = (#imageLiteral(resourceName: resourceName))
    }
}
