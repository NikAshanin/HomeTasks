import Foundation

import UIKit

final class WebsiteTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!

    func setText(_ text: String) {
        nameLabel.text = text
    }
}
