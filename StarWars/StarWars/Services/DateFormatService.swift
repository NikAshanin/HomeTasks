import Foundation

final class DateFormatService {
    private static let formatString = "yyyy-mm-dd"
    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter
    }()

    static func getYear(from dateString: String) -> String? {
        guard let date = formatter.date(from: dateString) else {
            return nil
        }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return String(year)
    }
}
