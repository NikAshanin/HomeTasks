import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var textView: UILabel!
    
    weak var delegate: TextChangeProtocol?
    var film: FilmObject?
    var likeCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let film = film else { return }
        filmImage.image = UIImage(named: "\(film.imageName).jpg")
        textView.text = film.description
        title = film.filmName
        likeCount = film.likeCount
        like.setTitle("Like: \(likeCount)", for: .normal)
    }
    @IBOutlet weak var like: UIButton!
    @IBAction func submit(_ sender: Any) {
        likeCount+=1
        like.setTitle("Like: \(likeCount)", for: .normal)
        delegate?.textChange(likeCount)
    }
}
protocol TextChangeProtocol: class {
    func textChange(_ value: Int)
}
