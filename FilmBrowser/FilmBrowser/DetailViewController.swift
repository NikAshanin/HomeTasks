import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func likePressed(_ sender: UIButton) {
            film?.likes += 1
    }
    
    private func updateUI() {
        posterImageView?.image = film?.poster
        titleLabel?.text = film?.title
        descriptionLabel?.text = film?.descr
    }
    
}
