import Foundation

extension Double {
    static let formatter = NumberFormatter()

    var stringValue: String {
        Double.formatter.maximumFractionDigits = 9
        var stringFromDouble = Double.formatter.string(from: NSNumber(value: self))
        if stringFromDouble?.first == ".", let str = stringFromDouble {
            stringFromDouble = "0"+str
        }
        return stringFromDouble ?? "0"
    }
}
