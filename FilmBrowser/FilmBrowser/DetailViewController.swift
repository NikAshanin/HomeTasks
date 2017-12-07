import UIKit

protocol LikeCountChangeProtocol: class {
    func likeCountChange(_ value: Int)
}

final class DetailViewController: UIViewController {

    @IBOutlet private weak var filmLogoImageView: UIImageView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    @IBOutlet private weak var filmDescriptionLabel: UILabel!
    @IBOutlet private weak var likesButton: UIButton!
    @IBOutlet private weak var likesCountLabel: UILabel!

    private var count = Int()
    weak var delegate: LikeCountChangeProtocol?
    var filmDetail: FilmModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setFilmDetail()
    }

    private func setFilmDetail() {

        guard let logo = filmDetail?.logo,
            let likesCount = filmDetail?.like else { return }

        filmLogoImageView.image = UIImage(named: logo)
        count = likesCount
        filmDescriptionLabel.text = filmDetail?.description
        filmNameLabel.text = filmDetail?.name
        likesCountLabel.text = String(count)

    }

    private func chagesOnLike() {

        count += 1
        likesCountLabel.text = String(count)
        delegate?.likeCountChange(count)
    }

    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        chagesOnLike()
    }
}
