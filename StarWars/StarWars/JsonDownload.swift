import Foundation

class JsonDownload {
    typealias dictionaryJSON = [String:Any]
    func downloadJSON(searchName: String, finished: @escaping (([Film])->Void)) /*-> [Film]*/ {
        let group = DispatchGroup()
        let jsonDecode = JsonDecode()
        var films: [Film] = []
        guard let jsonURL = URL(string: "https://swapi.co/api/people/?search=\(searchName)") else {
            print("error in name")
            return
        }
        URLSession.shared.dataTask(with: jsonURL, completionHandler: { (data, _, error) in
            guard let data = data
                else {
                    print("no internet")
                    return
            }
            let (filmsString, name) = jsonDecode.getFromName(dataOfJson: data)
            for filmString in filmsString {
                let jsonURLOfFilm: URL = URL(string: filmString)!
                group.enter()
                URLSession.shared.dataTask(with: jsonURLOfFilm, completionHandler: { (dataOfFilm, _, error) in
                    let (title, releaseDate) = jsonDecode.getFilms(dataOfJson: dataOfFilm!)
                    films.append(Film(nameOfChar: name, nameOfFilm: title, dateOfFilm: releaseDate))
                    group.leave()
                }).resume()
                group.notify(queue: .main, execute: {
                    finished(films)
                })
            }
        }).resume()
    }
}

