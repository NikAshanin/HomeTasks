import Foundation

protocol JSONInitializable {
    init?(json: [String: Any])
}

protocol ParserProtocol {

    func parseArray<T: JSONInitializable>(_ data: Data) throws -> T
}

enum Response<ResponseType> {
    case success(ResponseType)
    case failure(Error)
}

final class SearchResultModel: JSONInitializable {

    private struct Keys {
        static let count = "count"
        static let charactersList = "results"
        static let name = "name"
        static let filmsURLs = "films"
    }

    let count: Int
    let charactersList: [[ String: Any ]]
    let nameAndFilmsList: [String: [String]]

    init?(json: [String: Any]) {
        guard
            let count = json[Keys.count] as? Int,
            let charactersList = json[Keys.charactersList] as? [[ String: Any ]]
            else { return nil }

        var nameAndFilmsList = [String: [String]]()
        for character in charactersList {
            guard let name = character[Keys.name] as? String, let filmsURLs = character[Keys.filmsURLs] as? [String] else {
                return nil
            }
            nameAndFilmsList[name] = filmsURLs
        }

        self.count = count
        self.charactersList = charactersList
        self.nameAndFilmsList = nameAndFilmsList
    }
}

final class FilmsModel: JSONInitializable {

    private struct Keys {
        static let title = "title"
        static let releaseDate = "release_date"
    }

    let title: String
    let releaseDate: String

    init?(json: [String: Any]) {
        guard
        let title = json[Keys.title] as? String,
        let date = json[Keys.releaseDate] as? String
            else { return nil }

        self.title = title
        self.releaseDate = date
    }
}
