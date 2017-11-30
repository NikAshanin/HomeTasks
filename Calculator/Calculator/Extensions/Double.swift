import Foundation

extension Double {
    var stringValue: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 9
        var stringFromDouble = formatter.string(from: NSNumber(value: self)) ?? ""
        if stringFromDouble.first == "."{
            stringFromDouble = "0"+stringFromDouble
        }
        return stringFromDouble
    }
}
