import Foundation

final class BaseNumberFormatter {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.locale = .current
        formatter.maximumFractionDigits = 9
        return formatter
    }()
    static let decimalSeparator = formatter.decimalSeparator ?? "."

    static func string(from double: Double) -> String? {
        return formatter.string(from: NSNumber(value: double))
    }

    static func double(from string: String) -> Double? {
        return formatter.number(from: string)?.doubleValue
    }
}
