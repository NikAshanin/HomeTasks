import Foundation
extension Formatter {
    static let number = NumberFormatter()
}

extension Double {
    func toString() -> String {
        Formatter.number.minimumFractionDigits = 0
        Formatter.number.maximumFractionDigits = 5
        Formatter.number.roundingMode = .halfEven
        Formatter.number.numberStyle = .decimal
        return Formatter.number.string(for: self) ?? ""
    }
}
