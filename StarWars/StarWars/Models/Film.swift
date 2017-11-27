import Foundation

public class Film {
    let filmName: String
    let year: Int

    init(name: String, year: Int ) {
        self.filmName = name
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
        self.year = year
    }
}
