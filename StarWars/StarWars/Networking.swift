import Foundation

final class Networking {
    typealias JSONDictionary = [String: Any]

    private let session = URLSession.shared
    private var searchCharacterDataTask: URLSessionDataTask?

    func searchCharacter(_ searchString: String, completion: @escaping ([Film]?, String?) -> Void) {
        searchCharacterDataTask?.cancel()

        guard let rightSearchName = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://swapi.co/api/people/?search=\(rightSearchName)") else {
                completion(nil, nil)
                print("wrong URl")
                return
        }
        var json: JSONDictionary?
        searchCharacterDataTask = session.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(nil, nil)
                return
            }

            guard let json = json,
                let results = json["results"] as? [JSONDictionary],
                let firstResult = results.first,
                let name = firstResult["name"] as? String else {
                    completion(nil, nil)
                    print("no result")
                    return
            }
            self?.updateFilms(firstResult) { films in
                guard let films = films else {
                    return
                }
                completion(films, name)
            }
        }
        searchCharacterDataTask?.resume()
    }

    private func updateFilms(_ json: JSONDictionary, completion: @escaping ([Film]?) -> Void) {
        var films: [Film] = []
        let group = DispatchGroup()
        var filmsJSON: JSONDictionary?
        guard let filmsURLs = json["films"] as? [String] else {
            completion(nil)
            return
        }
        for film in filmsURLs {
            guard let url = URL(string: film) else {
                completion(nil)
                return
            }
            group.enter()
            session.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    group.leave()
                    completion(nil)
                    return
                }
                do {
                    filmsJSON = try (JSONSerialization.jsonObject(with: data, options: []) as? Networking.JSONDictionary)
                } catch let error as NSError {
                    group.leave()
                    completion(nil)
                    print(error.localizedDescription)
                }
                guard let filmsJSON = filmsJSON,
                    let title = filmsJSON["title"] as? String,
                    let date = filmsJSON["release_date"] as? String,
                    let releaseDate = BaseDateFormatter.backendDate(from: date) else {
                        group.leave()
                        completion(nil)
                        print("no title")
                        return
                }
                films.append(Film(title: title, releaseDate: releaseDate))
                group.leave()
            }.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            completion(films)
        }
    }
}
