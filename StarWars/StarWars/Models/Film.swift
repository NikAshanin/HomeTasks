import Foundation

public class Film {
    let filmName: String!
    let releaseDate: Date!
    let year: Int?

    init(name: String, releaseDate: Date, year: Int ) {
        self.filmName = name
        self.releaseDate = releaseDate
        self.year = year
    }

    let dateFormatter = DateFormatter()

    init?(json: [String: Any]?) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let json = json,
            let title = json["title"] as? String,
            let releaseDateString = json["release_date"] as? String,
            let releaseDate = dateFormatter.date(from: releaseDateString)
            else {
                return nil
        }
        let year = Calendar.current.component(.year, from: releaseDate)
        self.filmName = title
        self.releaseDate = releaseDate
        self.year = year
    }
}
