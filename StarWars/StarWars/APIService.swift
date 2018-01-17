import Foundation

typealias JSONDictionary = [String: Any]
final class APIService {
    private let searchURL = "https://swapi.co/api/people/?search="
    private let session = URLSession.shared

    private func parseCharacters(from jsons: [JSONDictionary]) -> [Character] {
        var characters = [Character]()
        for characterJSON in jsons {
            guard let name = characterJSON["name"] as? String,
                let filmsURL = characterJSON["films"] as? [String] else {
                    continue
            }
            var films = [Film]()
            for filmURL in filmsURL {
                guard let url = URL(string: filmURL) else {
                    continue
                }
                films.append(Film(url: url))
            }
            characters.append(Character(name: name, films: films))
        }
        return characters
    }

    func searchCharacters(searchText: String, completion: @escaping (([Character]) -> Void)) {
        guard let validSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: searchURL + validSearchText) else {
                completion([])
                return
        }
        let task = session.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                let characterJSON = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDictionary,
                let charactersJSON = characterJSON["results"] as? [JSONDictionary] else {
                    return
            }
            let characters = self?.parseCharacters(from: charactersJSON) ?? []
            DispatchQueue.main.async {
                completion(characters)
            }
        }
        task.resume()
    }

    func fetchFilms(characters: [Character], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for characters in characters {
            for film in characters.films {
                group.enter()
                let task = self.session.dataTask(with: film.url) { (data, _, _) in
                    guard let data = data,
                        let filmJSON = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDictionary,
                        let name = filmJSON["title"] as? String,
                        let date = filmJSON["release_date"] as? String else {
                            group.leave()
                            return
                    }
                    film.date = date
                    film.name = name
                    group.leave()
                }
                task.resume()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
}
