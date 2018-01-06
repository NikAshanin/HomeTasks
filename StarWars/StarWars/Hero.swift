import Foundation

final class Hero {

    let name: String
    let films: [Film]
    let info: [String: Any]

    init(info: [String: Any], name: String, films: [Film] ) {
        self.info = info
        self.name = name
        self.films = films
    }
}
