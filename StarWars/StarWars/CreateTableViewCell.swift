import UIKit

final class CreateTableViewCell: UITableViewCell {
    @IBOutlet private weak var labelName: UILabel!
       func setLabelName(name: String) {
               labelName.text = name
           }

}
