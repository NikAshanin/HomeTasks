import UIKit

final class FilmTableViewCell: UITableViewCell {

    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var anonceImage: UIImageView!
    @IBOutlet weak private var likesNumber: UILabel!
    @IBOutlet weak private var likes: UIButton!
    var film: Film?

    @IBAction func likePressed(_ sender: Any) {
        var like: Int = Int(self.likesNumber.text ?? "0") ?? 0
        like += 1
        self.likesNumber.text = String(like)
        self.film?.likes = like
    }

    func set(title: String, image: String, likes: Int, defaultWidth: CGFloat) {
        self.title.text = title
        let imageHeight: CGFloat = UIImage(named: image)?.size.height ?? 0
        guard let imageWidth: CGFloat = UIImage(named: image)?.size.width else {
            return
        }
        let height = defaultWidth * imageHeight / imageWidth
        let newSize = CGSize(width: defaultWidth, height: height)
        let imageOld = UIImage(named: image)

        self.anonceImage.image = imageOld?.resizeImageWith(newSize: newSize)
        self.anonceImage.clipsToBounds = true
        self.likesNumber.text = String(likes)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIImage {

    func resizeImageWith(newSize: CGSize) -> UIImage {

        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("image resize error")
        }
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension FilmTableViewCell: ChangeLikesProtocol {

    func changeLikes(_ value: String) {
        self.likesNumber.text = value
        film?.likes = Int(value) ?? 0
    }
}
