import UIKit

class FilmTableViewCell: UITableViewCell {

    @IBOutlet private weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setTitle(title: String) {
        self.title.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
