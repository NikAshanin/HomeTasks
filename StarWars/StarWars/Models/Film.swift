import Foundation

final class Film {
    let name: String
    let year: Int

    init(name: String, year: Int ) {
        self.name = name
        self.year = year
    }

    init?(json: [String: Any]?) {
        guard let json = json,
            let title = json["title"] as? String,
            let releaseDateString = json["release_date"] as? String
            else {
                return nil
        }
        let year = BaseDateFormatter.getOnlyYear(stringDate: releaseDateString)
        self.name = title
        self.year = year
    }
}
