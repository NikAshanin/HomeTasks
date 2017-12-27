import Foundation
extension Formatter {

    static let number: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.roundingMode = .halfEven
        formatter.numberStyle = .decimal
        return formatter
    }()

}

extension Double {
    func toString() -> String {
        return Formatter.number.string(for: self) ?? ""
    }
}
