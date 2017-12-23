import Foundation

final class NetworkService {
    typealias JSON = [String: Any]

    private let session = URLSession.shared
    private var characterDataTask: URLSessionDataTask?

    func getCharacter(characterName: String,
                      completion: @escaping (_ characterName: String?, _ films: [Film], _ errorString: String?) -> Void) {

        characterDataTask?.cancel()
        guard let suitableSearchName = characterName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://swapi.co/api/people/?search=\(suitableSearchName)") else {
                completion(nil, [], "wrong url")
                return
        }
        var json: JSON?
        characterDataTask = session.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data else {
                completion(nil, [], error.debugDescription)
                return
            }
            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
            } catch let error {
                completion(nil, [], error.localizedDescription)
                return
            }
            guard let json = json,
                let resultJson = json["results"] as? [JSON],
                let characterJson = resultJson.first,
                let name = characterJson["name"] as? String else {
                    completion(nil, [], "Empty result")
                    return
            }
            self?.getFilms(characterJson) { films in
                completion(name, films, nil)
            }
        }
        characterDataTask?.resume()
    }

    private func getFilms(_ json: JSON, completion: @escaping (_ films: [Film]) -> Void) {
        var films: [Film] = []
        let group = DispatchGroup()
        var filmJson: JSON?
        guard let filmsUrls = json["films"] as? [String] else {
            completion(films)
            return
        }
        for filmUrl in filmsUrls {
            guard let url = URL(string: filmUrl) else {
                completion(films)
                print("Incorrect url: " + filmUrl)
                return
            }
            group.enter()
            session.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    print(error.debugDescription)
                    group.leave()
                    return
                }
                do {
                    filmJson = try (JSONSerialization.jsonObject(with: data, options: []) as? JSON)
                } catch let error {
                    print(error.localizedDescription)
                    group.leave()
                }
                guard let filmJson = filmJson,
                    let title = filmJson["title"] as? String,
                    let dateString = filmJson["release_date"] as? String,
                    let year = DateFormatService.getYear(from: dateString) else {
                        print("Unsuitable type of date")
                        group.leave()
                        return
                }
                let film = Film(title: title, year: year)
                films.append(film)
                group.leave()
            }.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            completion(films)
        }
    }
}
