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
    public static let decimalSeparator = formatter.decimalSeparator ?? "."
    /// Serialize double into string
    public static func string(with double: Double) -> String? {
        return formatter.string(from: NSNumber(value: double))
    }

    public static func double(from string: String) -> Double? {
        return formatter.number(from: string)?.doubleValue
    }
}
