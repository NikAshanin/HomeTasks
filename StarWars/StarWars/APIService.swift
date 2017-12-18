import Foundation

typealias JSONDictionary = [String: Any]
final class APIService {
    private let searchURL = "https://swapi.co/api/people/?search="
    private let session = URLSession.shared

    private func parseCharacters(JSONs: [JSONDictionary]) -> [Character] {
        var characters = [Character]()
        for characterJSON in JSONs {
            guard let name = characterJSON["name"] as? String,
                let filmsURL = characterJSON["films"] as? [String] else {
                    return []
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
        DispatchQueue.global().async { [weak self] in
            guard let validSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let searchUrl = self?.searchURL,
                let url = URL(string: searchUrl + validSearchText) else {
                    completion([])
                    return
            }
            let task = self!.session.dataTask(with: url) {[weak self] (data, _, _) in
                guard let data = data,
                    let personageJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDictionary,
                    let personages = personageJson["results"] as? [JSONDictionary] else {
                        return
                }

                DispatchQueue.main.async {
                    completion(self?.parseCharacters(JSONs: personages) ?? [])
                }
            }
            task.resume()
        }
    }

    func fetchFilms(personages: [Character], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            for personage in personages {
                for film in personage.films {
                    group.enter()
                    let task = self.session.dataTask(with: film.url) { (data, _, _) in
                        guard let data = data,
                            let filmJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDictionary,
                            let name = filmJson["title"] as? String,
                            let date = filmJson["release_date"] as? String else {
                                return
                        }
                        film.date = date
                        film.name = name
                        group.leave()
                    }
                    task.resume()
                }
                group.wait()
            }
            group.notify(queue: DispatchQueue.main) {
                completion()
            }
        }
    }
}
