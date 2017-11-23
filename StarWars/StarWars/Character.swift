import Foundation

class Character {

    let name: String
    var films: [(String, String)] {
        return filmsData
    }
    private var filmsData: [(String, String)]
    private let info: [String: Any]

    init(from info: [String: Any]) {
        self.info = info
        filmsData = []
        let name = info["name"] as? String
        self.name = name ?? "?"
    }

    func fetchFilms(callback: @escaping () -> Void) {
        guard let filmsUrl = info["films"] as? [String] else {
            return
        }
        let session = URLSession.shared
        let group = DispatchGroup()
        for filmUrl in filmsUrl {
            guard let url = URL(string: filmUrl) else {
                continue
            }
            group.enter()
            let task = session.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] {
                    let filmName = json["title"] as? String ?? "no film title"
                    let filmDate = json["release_date"] as? String ?? "no film date"
                    self?.filmsData.append((filmName, filmDate))
                    group.leave()
                }
            }
            task.resume()
        }
        group.notify(queue: .global()) {
            callback()
        }
    }
}
