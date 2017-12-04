import Foundation

import UIKit

final class WebsiteTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setText(_ text: String) {
        nameLabel.text = text
    }
}
