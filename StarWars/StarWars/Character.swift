import Foundation

class Character {

    let name: String
    let films: [(String, String)]   
    private let info: [String: Any]
    
    init(info: [String: Any]) {
        self.info = info
        guard let name = info["name"] as? String, let filmsUrl = info["films"] as? [String] else {
        self.name = "?"
        self.films = []
            return
        }
        self.name = name
        let session = URLSession(configuration: .default)
        var tempArray = [(String, String)]()
        let group = DispatchGroup()
        for filmUrl in filmsUrl {
            guard let url = URL(string: filmUrl) else {
                films = []
                return
            }
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
        films = tempArray
    }
}
