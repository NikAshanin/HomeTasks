import Foundation

final class Character {
    let name: String
    let films: [Film]

    init(name: String, films: [Film]) {
        self.name = name
        self.films = films
    }
}
