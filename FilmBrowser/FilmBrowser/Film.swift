import Foundation

struct Film {
    var name = ""
    var description = ""
    var countLikes = 0
    var urlImage = ""

    mutating func increaseLikes() {
        countLikes += 1
    }
}
final class ArrayFilms {
    private var films: [Film] = []

    func pushFilm(name: String, description: String, urlImage: String) {
        var film = Film()
        film.name = name
        film.description = description
        film.countLikes = Int(arc4random() % 1_000)
        film.urlImage = urlImage
        films.append(film)
    }
    func get(index: Int) -> Film {
        return films[index]
    }
    func count() -> Int {
        return films.count
    }
    func changeLikes(_ nameFilm: String) {
        for var film in films where film.name == nameFilm {
            film.increaseLikes()
        }
    }
}
