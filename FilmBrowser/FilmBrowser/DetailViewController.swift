import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var filmLabel: UILabel!
    @IBOutlet private weak var filmDescriptionLabel: UILabel!
    weak var delegate: LikesChangeProtocol?
    var filmInCell: Film?
    var cellIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadFilmData()
    }
    
    @IBAction private func submitLike(_ sender: Any) {
        guard var likesCount = filmInCell?.likesCount else {
            return
        }
        likesCount += 1
        likeButton.setTitle(String(likesCount), for: UIControlState.normal)
        delegate?.likesChangeAt(cellIndex)
    }
    
    private func downloadFilmData() {
        guard let likesCount =  filmInCell?.likesCount, let photoName = filmInCell?.photo,
            let filmTitle = filmInCell?.name  else {
            return
        }
        likeButton.setTitle(String(likesCount), for: UIControlState.normal)
        filmImageView.image =  UIImage(named: photoName)
        filmLabel.text = filmTitle
        guard let fileURLProject = Bundle.main.path(forResource: "FilmsDescriptions", ofType: "txt") else {
            return
        }
        let descriptions = try? String(contentsOfFile: fileURLProject, encoding: String.Encoding.utf8)
        let arrayOfDescriptions = descriptions?.components(separatedBy: "//") ?? [""]
        filmDescriptionLabel.text = arrayOfDescriptions[cellIndex]
    }
}

protocol LikesChangeProtocol: class {
    func likesChangeAt(_ selectedCell: Int)
}
