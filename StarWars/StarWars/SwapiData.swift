import Foundation

final class SwapiData {
    let name: String
    let year: Int?

    init(filmName name: String, filmDate year: String) {
        self.name = name
        let intYear = SwapiData.getYearFromString(year)
        self.year = intYear
    }

    private static func getYearFromString(_ stringYear: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        guard let year = dateFormatter.date(from: stringYear) else {
            return nil
        }
        return Calendar.current.component(.year, from: year)
    }
}
