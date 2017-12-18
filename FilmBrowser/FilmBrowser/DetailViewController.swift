import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var filmImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var filmLabel: UILabel!
    @IBOutlet private weak var filmDescriptionLabel: UILabel!
    weak var delegate: LikesChangeProtocol?
    var likesCount = 0
    var photoName = ""
    var filmTitle = ""
    var filmIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadFilmData()
    }
    
    @IBAction func submitLike(_ sender: Any) {
        likesCount += 1
        likeButton.setTitle(String(likesCount), for: UIControlState.normal)
        delegate?.likesChange(String(likesCount))
    }
    
    func downloadFilmData() {
        likeButton.setTitle(String(likesCount), for: UIControlState.normal)
        filmImageView.image =  UIImage(named: photoName)
        filmLabel.text = filmTitle
        guard let fileURLProject = Bundle.main.path(forResource: "FilmsDescriptions", ofType: "txt") else {
            return
        }
        let descriptions = try? String(contentsOfFile: fileURLProject, encoding: String.Encoding.utf8)
        let arrayOfDescriptions = descriptions?.components(separatedBy: "//") ?? [""]
        filmDescriptionLabel.text = arrayOfDescriptions[filmIndex]
    }
}

protocol LikesChangeProtocol: class {
    func likesChange(_ value: String)
}
