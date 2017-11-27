import Foundation

struct Film {
  var name: String = ""
  var description: String = ""
  var countLikes: Int = 0
  var urlImage: String = ""
}
final class ArrayFilms {
  private var films: [Film] = []
  func pushFilm(name: String, description: String, urlImage: String) {
    var film = Film()
      film.name = name
      film.description = description
      film.countLikes = Int(arc4random() % 1000)
      film.urlImage = urlImage
      films.append(film)
  }
  func get(index: Int) -> Film {
    return films[index]
  }
  func count() -> Int {
    return films.count
  }
  func changeLikes(_ index: Int) {
    films[index].countLikes += 1
  }
}
