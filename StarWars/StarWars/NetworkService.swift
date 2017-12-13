import Foundation

final class NetworkService {
    private let blankURL = "https://swapi.co/api/people/?search="
    private let session = URLSession.shared

    func searchFilmsLinks(searchText: String, resultArray: @escaping (([Personage]) -> Void)) {
        let group = DispatchGroup()
        var variableJson = [[String: Any]]()
        guard let validSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: blankURL + validSearchText) else {
                resultArray([])
                return
        }
        group.enter()
        let task = session.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                let personageJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let personages = personageJson["results"] as? [[String: Any]] else {
                    return
            }
            variableJson = personages
            group.leave()
        }
        task.resume()
        group.notify(queue: .global()) { [weak self] in
                self?.fetchFilms(personages: variableJson, resultArray: resultArray)
        }
    }

    private func fetchFilms(personages: [[String: Any]], resultArray: @escaping (([Personage]) -> Void)) {
        var personageArray = [Personage]()
        var personageName: String = ""
        var films = [Film]()
        let group = DispatchGroup()
        for personage in personages {
            guard let name = personage["name"] as? String,
                let filmsURL = personage["films"] as? [String] else {
                    resultArray([])
                    return
            }
            personageName = name
            for filmURL in filmsURL {
                guard let url = URL(string: filmURL) else {
                    continue
                }
                group.enter()
                let task = self.session.dataTask(with: url) { (data, _, _) in
                    guard let data = data,
                        let filmJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                        let name = filmJson["title"] as? String,
                        let year = filmJson["release_date"] as? String else {
                            return
                    }
                    films.append(Film(filmName: name, filmedIn: year))
                    group.leave()
                }
                task.resume()
            }
            group.wait()
            personageArray.append(Personage(personage: personageName, starredInFilms: films))
            films.removeAll()
        }
        group.notify(queue: DispatchQueue.main) {
            resultArray(personageArray)
        }
    }
}
