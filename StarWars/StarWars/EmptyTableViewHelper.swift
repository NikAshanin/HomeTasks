import UIKit

final class EmptyTableViewHelper {
    static func emptyViewWith(message: String, tableView: UITableView) {
        let width = tableView.bounds.size.width
        let height = tableView.bounds.size.height

        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 17)
        messageLabel.sizeToFit()
        emptyView.addSubview(messageLabel)
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true

        tableView.backgroundView = emptyView
    }

}
