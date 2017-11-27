import Foundation

private enum PossibleURIs: String {
    case filmById = "https://swapi.co/api/films/"
    case characterByName = "https://swapi.co/api/people/?search="
}

final class NetworkService {

    private let session = URLSession.shared

    func request(url: String, completionHandler: @escaping (_ result: [String: Any]?) -> Void) {
        guard let requestUrl = URL(string: url) else {
            return
        }
        let request = URLRequest(url: requestUrl)
        let task = session.dataTask(with: request) { (data, _, error) in
            guard let error = error,
                let usableData = data else {
                    return completionHandler(nil) }

                let json = try? JSONSerialization.jsonObject(with: usableData, options: [])
                if let dict = json as? [String: Any] {
                    completionHandler(dict)
                } else {
                    completionHandler(nil)
                }
        }
        task.resume()
    }

}

extension NetworkService {

    func getFilms(characterName: String,
                  completionHandler: @escaping (_ films: [Film]) -> Void) {
        var films = [Film]()
        let group = DispatchGroup()
        let queue = DispatchQueue.global()

        group.enter()
        getFilmsWithCharacterByHisName(characterName) { [weak self] links in
            links?.forEach({ link in
                group.enter()
                self?.getFilmByLink(link) { film in
                    if let film = film {
                        films.append(film)
                    }
                    group.leave()
                }
            })
            group.leave()
        }

        group.notify(queue: queue, execute: {
            completionHandler(films)
        })
    }

    private func getFilmByLink(_ link: String,
                               completionHandler: @escaping (_ film: Film?) -> Void) {
        request(url: link) { data in
            completionHandler(Film(json: data))
        }
    }

    private func getFilmsWithCharacterByHisName(_ characterName: String,
                                                completionHandler: @escaping (_ films: [String]?) -> Void) {
        let urlString = PossibleURIs.characterByName.rawValue + characterName
        request(url: urlString) { [weak self] data in
            completionHandler(self?.getCharacterFromJSON(json: data)?.linksToFilmsWithCharacter)
        }
    }

    private func getCharacterFromJSON(json: [String: Any]?) -> Character? {
        guard let json = json, isCharacterExist(json: json),
            let results = json["results"] as? [[String: Any]],
            let firstCharacter = results.first,
            let characterName = firstCharacter["name"] as? String,
            let films = firstCharacter["films"] as? [String] else {
            return nil
        }
        return Character(name: characterName, links: films)
    }

    private func isCharacterExist(json: [String: Any]) -> Bool {
        guard let charactersCount = json["count"] as? Int, charactersCount > 0 else {
            return false
        }
        return true
    }

}
