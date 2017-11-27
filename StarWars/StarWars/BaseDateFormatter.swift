import Foundation
final class BaseDateFormatter {
    private static let yearMonthDayFormat = "yyyy-mm-dd"

    private static let apiOnlyYearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = yearMonthDayFormat
        return dateFormatter
    }()

    public static func getOnlyYear(stringDate: String) -> Int {
        guard let date = apiOnlyYearFormatter.date(from: stringDate) else {
            return -1
        }
        return Calendar.current.component(.year, from: date)
    }
}
