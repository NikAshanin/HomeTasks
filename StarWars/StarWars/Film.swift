import Foundation

final class Film {
    public var title: String
    public var year: Date

    init(title: String, year: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let formattedDate = formatter.date(from: year) else {
            fatalError("date is wrong")
        }
        self.year = formattedDate
        self.title = title
    }

    func getFilm() -> (String, Date) {
        return(self.title, self.year)
    }
}
