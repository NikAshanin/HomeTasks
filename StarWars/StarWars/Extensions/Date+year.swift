import Foundation

extension Date {
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: self)
        return year
    }
}
