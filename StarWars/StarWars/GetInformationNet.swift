import Foundation

struct NameFilmWithDate {
    let nameFilm: String
    let dateFilm: String
    init(nameFilm: String, dateFilm: String) {
        self.nameFilm = nameFilm
        self.dateFilm = dateFilm
    }
}

final class GetInformationNet {

    private var nameFilms: [NameFilmWithDate] = []
    private var dataTask: URLSessionDataTask?
    private let session = URLSession.shared
    private let sessionTest = URLSession.shared
    typealias CallBack = (_ result: [NameFilmWithDate], _ name: String) -> Void
    func getJsonFromUrl(searchNameCharacter: String, completion: @escaping CallBack) {
        dataTask?.cancel()
        guard let searchName = searchNameCharacter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else { return }
        guard let url = URL(string: "https://swapi.co/api/people/?search=\(searchName)") else { return }
        dataTask = session.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
            guard let data = data else { return }
            let jsonObj: [String: Any]
            do {
                jsonObj = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
            } catch let error as NSError {
                print(error.localizedDescription)
                return
            }
            guard let searchResult = (jsonObj["results"] as? [[String: Any]])?.first else { return }
            guard let nameCharacter = searchResult["name"] as? String else { return }
            self?.updateInformation(jsonObj: searchResult, name: nameCharacter, completion: completion)
        })
        dataTask?.resume()
        }
    private func updateInformation(jsonObj: [String: Any], name: String, completion: @escaping CallBack) {
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
            let dataTask = self.session.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
                guard let data = data else {return}
                var jsonObj: [String: Any]?
                do {
                    jsonObj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                guard let nameFilm = jsonObj!["title"] as? String, let dateFilm = jsonObj!["release_date"] as? String else {return}
                self?.nameFilms.append(NameFilmWithDate(nameFilm: nameFilm, dateFilm: dateFilm))
                group.leave()
            })
            dataTask.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            print(self.nameFilms)
            completion(self.nameFilms, name)
        }
    }
}
