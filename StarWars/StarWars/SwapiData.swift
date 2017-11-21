import Foundation

class SwapiCharacter {
    var name: String = ""
    var url: String = ""
    var filmIndexes: Set<Int> = []
}

class SwapiFilm {
    var name: String = ""
    var date: String = ""
}

class SwapiData {
    private var films: [SwapiFilm] = []
    private var characters: [SwapiCharacter] = []

    func push_back(filmName: String, filmDate: String) {
        let film = SwapiFilm()
        film.name = filmName
        film.date = filmDate

        films.append(film)
    }

    func push_back(charName: String, url: String) {
        let character = SwapiCharacter()
        character.name = charName
        character.url = url

        characters.append(character)
    }
    func clearFilms() {
        films.removeAll()
    }
    func clearCharacters() {
        characters.removeAll()
    }

    func getCharacter(index: Int) -> SwapiCharacter {
        return characters[index]
    }
    func getFilm(index: Int) -> SwapiFilm {
        return films[index]
    }
    func filmCount() -> Int {
        return films.count
    }
    func characterCount() -> Int {
        return characters.count
    }
}
