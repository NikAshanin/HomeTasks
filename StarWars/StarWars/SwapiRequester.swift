import Foundation

class SwapiRequester {
    var swData = SwapiData()
    let queue = DispatchQueue(label: "network thread to work with swapi.co web resource")
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var swURL = "https://swapi.co/api/"
    var controller: ViewController?
    var films: [String] = []

    func setController(_ controller: ViewController) {
        self.controller = controller
    }

    func updateController(isFilms: Bool = false) {
        if isFilms == true {
            controller?.updateData(isFilms: true)
        } else {
            controller?.updateData()
        }
    }

    func loadData() {
        queue.async {
            self.loadCharacters()
        }
    }

    private func loadCharacters(_ newURL: String = "") {
        var strURL = ""
        if newURL != "" {
            strURL = newURL
        } else {
            strURL = swURL + "people/"
        }

        guard let url = URL(string: strURL) else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { data, _, error in
            defer { self.dataTask = nil }
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data,
                    let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let results = responseData["results"] as? [[String: Any]] {
                    for result in results {
                        if let name = result["name"] as? String,
                            let url = result["url"] as? String {
                            self.swData.push_back(charName: name, url: url)
                        }
                    }
                    if let nextPageURL = responseData["next"] as? String {
                        if nextPageURL == "null" {
                            return
                        }
                        self.loadCharacters(nextPageURL)
                    }
                    self.updateController()
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        dataTask?.resume()
    }

    private func loadFilms(_ filmURL: String = "") {
        let semaphore = DispatchSemaphore(value: 0)

        var strURL = ""
        if filmURL != "" {
            strURL = filmURL
        } else {
            return
        }

        guard let url = URL(string: strURL) else {
            return
        }

        dataTask = defaultSession.dataTask(with: url) { data, _, error in
            defer { self.dataTask = nil }
            do {
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data,
                    let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let title = responseData["title"] as? String,
                            let date = responseData["release_date"] as? String {
                            self.swData.push_back(filmName: title, filmDate: date)
                        }
                    }
                semaphore.signal()
            } catch let error as NSError {
                print(error.localizedDescription)
                semaphore.signal()
            }
        }
        dataTask?.resume()
        semaphore.wait()
    }

    func getFilms(characterURL: String) {
        let semaphore = DispatchSemaphore(value: 0)
        self.swData.clearFilms()
        guard let url = URL(string: characterURL) else {
            return
        }
        self.dataTask = self.defaultSession.dataTask(with: url) { data, _, error in
            defer { self.dataTask = nil }
            do {
                self.films.removeAll()
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data,
                    let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let testFilms = responseData["films"] as? [String] {
                        self.films = testFilms
                }
                semaphore.signal()
            } catch let error as NSError {
                print(error.localizedDescription)
                semaphore.signal()
            }
        }
        self.dataTask?.resume()
        semaphore.wait()
        for film in films {
            self.loadFilms(film)
        }
        self.updateController(isFilms: true)
    }
}
