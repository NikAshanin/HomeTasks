import Foundation

class Film {
    let name: String
    let dateFilm: Date

    init(nameFilm: String, dateFilm: Date) {
        self.name = nameFilm
        self.dateFilm = dateFilm
    }
}

final class NetworkService {
    private let session = URLSession.shared

    typealias CallBack = (_ result: [Film], _ name: String) -> Void

    func getJsonFromUrl(searchNameCharacter: String, completion: @escaping CallBack) {
        dataTask?.cancel()
        guard let searchName = searchNameCharacter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: "https://swapi.co/api/people/?search=\(searchName)")
            else {
                return
        }
       let dataTask = session.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
            guard let data = data else {
                return
            }
            let jsonObj: [String: Any]?
            do {
                jsonObj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let error as NSError {
                print(error.localizedDescription)
                return
            }
            guard let jsonObject = jsonObj, let searchResult = (jsonObject["results"] as? [[String: Any]])?.first,
                let nameCharacter = searchResult["name"] as? String else {
                return
            }
            self?.updateInformation(jsonObj: searchResult, name: nameCharacter, completion: completion)
        })
        dataTask?.resume()
        }

    private func updateInformation(jsonObj: [String: Any], name: String, completion: @escaping CallBack) {
        var nameFilms: [Film]
        nameFilms.removeAll()
        let group = DispatchGroup()

        guard let filmsCharacter = jsonObj["films"] as? [String] else {
            return
        }
        for filmName in filmsCharacter {
            guard let url = URL(string: filmName) else {
                continue
            }
            group.enter()
            self.session.dataTask(with: url, completionHandler: { (data, _, error) in
                guard let data = data else {
                    return
                }
                var jsonFilm: [String: Any]?
                do {
                    jsonFilm = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                guard let jsonObj = jsonFilm, let nameFilm = jsonObj["title"] as? String,
                let dateFilm = jsonObj["release_date"] as? String,
                let date = formatting.date(from: dateFilm) else {
                    return
                }
                nameFilms.append(Film(nameFilm: nameFilm, dateFilm: date))
                group.leave()
            }).resume()
        }
        group.notify(queue: DispatchQueue.main) {
            print(nameFilms)
            completion(nameFilms, name)
        }
    }
}

let formatting: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format
}()
