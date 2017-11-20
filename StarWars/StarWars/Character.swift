import Foundation

class Character {

    let name: String
    var films: [(String, String)] {
        if filmsNames == nil {
            fetchFilmNames()
        }
        return filmsNames ?? []
    }
    
    private var filmsNames: [(String, String)]?
    private let info: [String: Any]
    
    init(info: [String: Any]) {
        self.info = info
        let name = info["name"] as? String
        self.name = name ?? "no name"
    }
    
    private func fetchFilmNames() {
        guard let filmsUrl = info["films"] as? [String] else {
            filmsNames = []
            return
        }
        let session = URLSession(configuration: .default)
        var tempArray = [(String, String)]()
        let group = DispatchGroup()
        for filmUrl in filmsUrl {
            let url = URL(string: filmUrl)!
            group.enter()
            let task = session.dataTask(with: url) {(data, _, _) in
                if let data = data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] {
                    let filmName = json["title"] as? String ?? "no film title"
                    let filmDate = json["release_date"] as? String ?? "no film date"
                    tempArray.append((filmName, filmDate))
                    group.leave()
                }
            }
            task.resume()
        }
        group.wait()
        filmsNames = tempArray
    }
}
