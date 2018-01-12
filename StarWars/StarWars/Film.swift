import Foundation

final class Film {
    let name: String
    let year: Int?
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()

    init(filmName name: String, filmedIn year: String) {
        self.name = name
        let intYear = Film.getYearFromString(year)
        self.year = intYear
    }

    private static func getYearFromString(_ stringYear: String) -> Int? {
        guard let year = dateFormatter.date(from: stringYear) else {
            return nil
        }
        return Calendar.current.component(.year, from: year)
    }
}
