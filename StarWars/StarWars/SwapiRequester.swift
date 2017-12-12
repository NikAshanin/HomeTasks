import Foundation

final class SwapiRequester {
    var swData = SwapiData()

    private let queue = DispatchQueue(label: "network thread to work with swapi.co web resource")
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var swURL = "https://swapi.co/api/"
    weak var dataReceieverDelegate: SwapiDataRecieverDelegate?
    private var films: [String] = []

    func loadData() {
        queue.async {
            self.loadCharacters()
        }
    }

    private func updateController(isFilms: Bool = false) {
        dataReceieverDelegate?.dataIsReady(isFilms: isFilms)
    }

    private func request(strURL: String) -> Any? {
        let group = DispatchGroup()

        guard let url = URL(string: strURL) else {
            return nil
        }

        group.enter()
        var returnValue: Any?
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, _, error in
            defer { self?.dataTask = nil }
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    returnValue = try JSONSerialization.jsonObject(with: data, options: [])
                }
                group.leave()
            } catch let error as NSError {
                print(error.localizedDescription)
                group.leave()
            }
        }

        dataTask?.resume()
        group.wait()
        return returnValue
    }

    private func loadCharacters(_ newURL: String = "") {

        guard let response = request(strURL: newURL != "" ? newURL : swURL + "people/") as? [String: Any] else {
            return
        }

        if let results = response["results"] as? [[String: Any]] {
            for result in results {
                if let name = result["name"] as? String,
                    let url = result["url"] as? String {
                    swData.push_back(charName: name, url: url)
                }
            }
            if let nextPageURL = response["next"] as? String {
                if nextPageURL == "null" {
                    return
                }
                dataReceieverDelegate?.dataIsReady(isFilms: false)
                loadCharacters(nextPageURL)
            }
        }
    }

    private func loadFilm(_ filmURL: String = "") {
        guard let response = request(strURL: filmURL) as? [String: Any] else {
                return
        }
        if let title = response["title"] as? String,
            let date = response["release_date"] as? String {
            swData.push_back(filmName: title, filmDate: date)
        }
    }

    func getFilms(characterURL: String) {
        swData.clearFilms()

        if let response = request(strURL: characterURL) as? [String: Any] ,
           let filmsResponse = response["films"] as? [String] {
            films = filmsResponse
        }

        for film in films {
            loadFilm(film)
        }

        dataReceieverDelegate?.dataIsReady(isFilms: true)
    }
}
