import Foundation

final class Personage {
    let name: String
    let films: [Film]

    init(personage name: String, starredInFilms films: [Film]) {
        self.name = name
        self.films = films
    }
}
