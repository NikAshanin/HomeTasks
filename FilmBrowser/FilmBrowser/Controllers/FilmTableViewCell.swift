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

     func selectImageForLikeState(_ film: Film) {
        if film.liked {
            likeImage.image = #imageLiteral(resourceName: "liked")
        } else {
            likeImage.image = #imageLiteral(resourceName: "like")
        }
        let resourceName = film.liked ? "liked" : "like"
        likeImage.image = (#imageLiteral(resourceName: resourceName))
    }
}
