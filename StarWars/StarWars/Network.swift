import Foundation
import UIKit

final class Network {
    var dispatchGroup = DispatchGroup()

    var json: Any?
    var result: String = ""
    var respond: NSDictionary = NSDictionary()
    var films: [String] = []
    var filmsArray: [Film] = []

    func transform(_ query: String) -> String {
        var newQuery = ""
        for each in query {
            if each == " " {
                newQuery += "%20"
            } else {
                newQuery += String(each)
            }

        }
        return newQuery
    }

    func getDataFrom(_ url: String, with queryValue: String) {
        filmsArray = []
        dispatchGroup.enter()

        let query = url + "?search=" + transform(queryValue)
        self.getDataFrom(query)
        dispatchGroup.wait()
        self.json = self.parse(self.respond, with: "results.films")
        guard let data = json as? [String] else {
            return
        }
        if data.isEmpty {
            return
        }

        for film in data {
            DispatchQueue.main.async {
                self.dispatchGroup.enter()
                self.getDataFrom(film)
                self.dispatchGroup.wait()
                guard let title = self.parse(self.respond, with: "title") as? String else {
                    fatalError("error")
                }
                self.films.append(title)
                guard let date = self.parse(self.respond, with: "release_date") as? String else {
                    fatalError("error")
                }
                let film = Film(title: title, year: date)
                self.filmsArray.append(film)
            }
        }
    }

    func getDataFrom(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                return
            }
            do {
                guard let responed = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    fatalError("error")
                }
                self.respond = responed
                self.dispatchGroup.leave()
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    func parse(_ json: NSDictionary, with key: String) -> Any? {
        let films = json.value(forKeyPath: key)
        if films is [[String]] {
            if let arrayOfFilms = films as? [[String]] {
                print(arrayOfFilms)
                print("arrayOfFilms")
                if arrayOfFilms.isEmpty {
                    return []
                } else {
                    return arrayOfFilms[0]
                }
            } else {
                return []
            }
        } else {
            return films
        }
    }
}
