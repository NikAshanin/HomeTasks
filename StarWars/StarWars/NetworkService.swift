import Foundation

final class NetworkService {
    private let blankURL = "https://swapi.co/api/people/?search="
    private let session = URLSession.shared

    func searchFilmsLinks(searchText: String, completionBlock: @escaping (([Personage]) -> Void)) {
        guard let validSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: blankURL + validSearchText) else {
                completionBlock([])
                return
        }
        let task = session.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                let personageJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let personages = personageJson["results"] as? [[String: Any]] else {
                    completionBlock([])
                    return
            }
            var personageArray = [Personage]()
            let group = DispatchGroup()
            for personage in personages {
                group.enter()
                DispatchQueue.global().async {
                    guard let name = personage["name"] as? String,
                        let filmsURL = personage["films"] as? [String] else {
                            group.leave()
                            completionBlock([])
                            return
                    }
                    self?.fetchFilms(filmsURL: filmsURL) { films in
                        personageArray.append(Personage(personage: name, starredInFilms: films))
                    }
                    group.leave()
                }
            }
            group.notify(queue: DispatchQueue.main) {
                completionBlock(personageArray)
            }
        }
        task.resume()
    }

    private func fetchFilms(filmsURL: [String], completionBlock: @escaping (([Film]) -> Void)) {
        var films = [Film]()
        let group = DispatchGroup()
        for filmURL in filmsURL {
            var filmJson: [String: Any]?
            guard let url = URL(string: filmURL) else {
                continue
            }
            group.enter()
            session.dataTask(with: url) { (data, _, error) in
                guard let data = data else {
                    group.leave()
                    return
                }
                do {
                    filmJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch let error as NSError {
                    group.leave()
                    print(error.localizedDescription)
                }
                guard let jsonObject = filmJson,
                    let name = jsonObject["title"] as? String,
                    let year = jsonObject["release_date"] as? String else {
                        group.leave()
                        return
                }
                films.append(Film(filmName: name, filmedIn: year))
                group.leave()
            }.resume()
        }
        group.wait()
        group.notify(queue: DispatchQueue.main) {
            completionBlock(films)
        }
    }
}
