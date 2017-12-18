import Foundation

final class NetworkService {
    typealias Callback = (_ result: [SwapiData], _ name: String) -> Void
    
    private let session = URLSession.shared

    func getJson(searchName: String, callback: @escaping Callback) {
        guard let searchNameResult = searchName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://swapi.co/api/people/?search=\(searchNameResult)")
            else {
                return
        }
       let dataTask = session.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
            guard let data = data else {
                callback([], "")
                return
            }
            let json: [String: Any]?
            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error)
                return
            }
            guard let resultJson = json, let searchResult = (resultJson["results"] as? [[String: Any]])?.first,
                let characterName = searchResult["name"] as? String else {
                    return
            }
            self?.downloadFilms(json: searchResult, name: characterName, callback: callback)
        })
        dataTask.resume()
    }

    private func downloadFilms(json: [String: Any], name: String, callback: @escaping Callback) {
        var swapiDataResults: [SwapiData] = []
        let group = DispatchGroup()
        guard let filmsList = json["films"] as? [String] else {
            return
        }
        for filmUrl in filmsList {
            guard let url = URL(string: filmUrl) else {
                continue
            }
            group.enter()
            let dataTask = self.session.dataTask(with: url, completionHandler: { (data, _, error) in
                guard let data = data else {
                    callback([], "")
                    return
                }
                var filmJson: [String: Any]?
                do {
                    filmJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch let error {
                    print(error)
                }
                guard let json = filmJson, let filmName = json["title"] as? String,
                    let filmDate = json["release_date"] as? String else {
                        return
                }
                swapiDataResults.append(SwapiData(filmName: filmName, filmDate: filmDate))
                group.leave()
            })
            dataTask.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            callback(swapiDataResults, name)
        }
    }
}
