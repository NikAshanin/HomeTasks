import Foundation

final class NetworkService {
    private var dataTask: URLSessionDataTask?
    private let session = URLSession.shared
    typealias DelayFunc = (_ result: [SwapiData], _ name: String) -> Void
    func getJson(searchName: String, callback: @escaping DelayFunc) {
        dataTask?.cancel()
        guard let url = URL(string: "https://swapi.co/api/people/?search=\(searchName)")
            else {
                return
            }
        dataTask = session.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
            guard let data = data else {
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
                let CharacterName = searchResult["name"] as? String else {
                return
            }
            self?.downloadFilms(json: searchResult, name: CharacterName, callback: callback)
        })
        dataTask?.resume()
        }
    private func downloadFilms(json: [String: Any], name: String, callback: @escaping DelayFunc) {
        var swapiDataResults: [SwapiData] = []
        swapiDataResults.removeAll()
        let group = DispatchGroup()
        guard let filmsList = json["films"] as? [String] else {
            return
        }
        for filmName in filmsList {
            guard let url = URL(string: filmName) else {
                continue
            }
            group.enter()
            let dataTask = self.session.dataTask(with: url, completionHandler: { (data, _, error) in
                guard let data = data else {
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
                swapiDataResults.append(SwapiData(name: filmName, date: filmDate))
                group.leave()
            })
            dataTask.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            callback(swapiDataResults, name)
        }
    }
}
