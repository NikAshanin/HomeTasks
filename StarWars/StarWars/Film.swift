import Foundation

class Film {
    let name: String
    let year: Int
    private let dateFormatter = DateFormatter()

    init(filmName name: String, filmedIn year: String) {
        self.name = name
        let intYear = Film.getYearFromString(year)
        self.year = intYear
    }

    private static func getYearFromString(_ stringYear: String) -> Int {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd"
            return formatter
        }()
        guard let year = dateFormatter.date(from: stringYear) else {
            return -1
        }
        return Calendar.current.component(.year, from: year)
    }
}
