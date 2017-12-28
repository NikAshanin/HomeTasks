import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var like: UILabel!
    @IBOutlet weak private var filmTitle: UILabel!
    public var film: Film?
    weak var delegate: ChangeLikesProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image: UIImage = UIImage(named: film?.image ?? "default.jpg")
            else { return }
        self.image.image = image.resizeImageWith(newSize: calculateImageSize(image: image))
        self.filmTitle.text = film?.title
        self.like.text = String(film?.likes ?? 0)
    }
    func calculateImageSize(image: UIImage) -> CGSize {
        let defaultWidth = self.view.frame.size.width
        let imageHeight: CGFloat = image.size.height
        let imageWidth: CGFloat = image.size.width
        let height = defaultWidth * imageHeight / imageWidth
        return CGSize(width: defaultWidth, height: height)
    }

    @IBAction func likePressed(_ sender: Any) {
        var like: Int = Int(self.like.text ?? "0") ?? 0
        like += 1
        self.like.text = String(like)
        delegate?.changeLikes(String(like))
    }
}

protocol ChangeLikesProtocol: class {

    func changeLikes(_ value: String)

}
