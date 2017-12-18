import Foundation

final class SwapiData {
    let name: String, year: Int?
    private static let dateFormatter = DateFormatter()

    init(filmName name: String, filmDate year: String) {
        self.name = name
        let intYear = SwapiData.getYearFromString(year)
        self.year = intYear
    }

    private static func getYearFromString(_ stringYear: String) -> Int? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd"
            return formatter
        }()
        guard let year = dateFormatter.date(from: stringYear) else {
            return nil
        }
        return Calendar.current.component(.year, from: year)
    }
}
