import UIKit
extension UILabel {
    func sizeToFitOnlyHeight(maxWidth: CGFloat) {
        let maxHeight = CGFloat.infinity
        let rect = self.attributedText?.boundingRect(with: CGSize(width: maxWidth,
                                                                  height: maxHeight), options: .usesLineFragmentOrigin,
                                                                                      context: nil)
        var frame = self.frame
        guard let safeRect = rect else {
            return }

        frame.size.height = safeRect.size.height
        self.frame = frame
    }
}
