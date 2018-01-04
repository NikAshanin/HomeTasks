import UIKit

final class CreateTableViewCell: UITableViewCell {
    @IBOutlet weak private var nameLabel: UILabel!

    func configure(name: String) {
        nameLabel.text = name
    }
}
