import UIKit
final class InfoViewModel {
    func filmsGet() -> [FilmObject] {
        guard let file = Bundle.main.url(forResource: "films", withExtension: "json")  else { return [] }
        do {
            let data = try Data(contentsOf: file)
            let films = try JSONDecoder().decode([FilmObject].self, from: data)
            return films
        } catch let dataError {
            print("\(dataError)")
        }
        return []
    }
}
