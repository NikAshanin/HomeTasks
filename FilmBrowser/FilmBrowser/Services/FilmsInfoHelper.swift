import Foundation

final class FilmsInfoHelper {
    static func getFilms() -> [Film] {
        guard let file = Bundle.main.url(forResource: "Films", withExtension: "json")  else {
            return []
        }
        do {
            let data = try Data(contentsOf: file)
            do {
                let films = try JSONDecoder().decode([Film].self, from: data)
                return films
            } catch let jsonDecoderError {
                print(jsonDecoderError.localizedDescription)
            }
        } catch let dataError {
            print(dataError.localizedDescription)
        }
        return []
    }
}
