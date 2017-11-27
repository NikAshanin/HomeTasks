import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak private var filmImage: UIImageView!
    @IBOutlet weak private var textView: UILabel!
    @IBOutlet weak private var like: UIButton!
    weak var delegate: TextChangeProtocol?
    var film: Film?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let film = film else { return }
        filmImage.image = UIImage(named: "\(film.imageName).jpg")
        textView.text = film.description
        title = film.name
        like.setTitle("Like: \(film.likeCount)", for: .normal)
    }
    @IBAction func submit(_ sender: Any) {
        film?.likeCount+=1
        like.setTitle("Like: \(film!.likeCount)", for: .normal)
        delegate?.textChange()
    }
}
protocol TextChangeProtocol: class {
    func textChange()
}
