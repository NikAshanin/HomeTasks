import Foundation

final class BaseDateFormatter {
    private static let yearMonthDayDateTimeFormat = "yyyy-MM-dd"

    private static let yearMonthDayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = yearMonthDayDateTimeFormat
        return dateFormatter
    }()

    static func backendDate(from strDate: String) -> Date? {
        return yearMonthDayFormatter.date(from: strDate)
    }
    static func getYear(from date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }

}
