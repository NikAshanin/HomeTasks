import Foundation

final class DataFormatterConfigurator {

    private static let yearMonthDayFormate = "yyyy-mm-dd"
    private static let calendar: Calendar = {
        Calendar.current
    }()

    private static let yearMonthDayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = yearMonthDayFormate
        return dateFormatter
    }()

    static func getYear(from date: String) -> String {
        guard let date = yearMonthDayFormatter.date(from: date) else {
            return "0"
        }
        let year = calendar.component(.year, from: date)
        return String(year)
    }
}
