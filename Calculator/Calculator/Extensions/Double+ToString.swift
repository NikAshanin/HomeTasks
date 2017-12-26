import Foundation
extension Formatter {
    static let number = NumberFormatter()
}

extension Double {
    static let number = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.number.roundingMode = .halfEven
        formatter.number.numberStyle = .decimal
        return formatter
    }()

    func toString() -> String {
        return Formatter.number.string(for: self) ?? ""
    }
}
