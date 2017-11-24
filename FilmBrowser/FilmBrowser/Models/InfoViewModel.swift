import UIKit
final class InfoViewModel {

    static func filmsFromBundle() -> [Film] {
        guard let file = Bundle.main.url(forResource: "films", withExtension: "json")  else {
            return []
        }
        do {
            let data = try Data(contentsOf: file)
            do {
                let films = try JSONDecoder().decode([Film].self, from: data)
                return films
            } catch let JSONError {
                print("no json: \(JSONError)")
            }
        } catch let dataError {
            print("no data: \(dataError)")
        }
        return []
    }
}
