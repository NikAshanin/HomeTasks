import Foundation

class NumberFormatterConfigurator: NumberFormatter {
    override init() {
        super.init()

        self.maximumFractionDigits = 6
        self.minimumFractionDigits = 0
        self.groupingSeparator = " "
        self.numberStyle = .decimal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
