import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var filmImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var filmLabel: UILabel!
    @IBOutlet private weak var filmDescription: UILabel!
    private let infoModel = FilmViewModel()
    weak var delegate: LikesChangeProtocol?
    var likesCount = 0
    var photoName = ""
    var filmTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadFilmData()
    }
    @IBAction func submitLike(_ sender: Any) {
        likesCount += 1
        likeButton.setTitle(String(likesCount), for: UIControlState.normal)
        delegate?.likesChange(String(likesCount))
    }
    func uploadFilmData() {
        likeButton.setTitle(String(likesCount), for: UIControlState.normal)
        let imageName = "0\(photoName)_film.jpg"
        filmImage.image =  UIImage(named: imageName)
        filmLabel.text = filmTitle
        guard let fileURLProject = Bundle.main.path(forResource: "FilmsDescriptions", ofType: "txt") else {
            return
        }
        let descriptions = try? String(contentsOfFile: fileURLProject, encoding: String.Encoding.utf8)
        let arrayOfDescriptions = descriptions?.components(separatedBy: "//") ?? [""]
        let rowNumber = Int(photoName) ?? 0
        filmDescription.text = arrayOfDescriptions[rowNumber - 1]
        print(arrayOfDescriptions[rowNumber - 1])
    }
}

protocol LikesChangeProtocol: class {
    func likesChange(_ value: String)
}
