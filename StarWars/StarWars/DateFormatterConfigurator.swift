import Foundation

class DataFormatterConfigurator: DateFormatter {

    override init() {
        super.init()
        self.dateFormat = "yyyy-mm-dd"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
