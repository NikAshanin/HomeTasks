//
//  Networking.swift
//  StarWars
//
//  Created by Artem Orlov on 19/11/2017.
//

import Foundation

final class Networking {
    typealias JSONDictionary = [String: Any]
//    typealias Film = (title: String, year: Date)

    private let session = URLSession(configuration: .default)
    private var films: [Film] = []
    private let group = DispatchGroup()
    private var dataTask: URLSessionDataTask?

    func getCharacter(_ searchName: String, complition: @escaping ([Film]?, String) -> Void) {
        dataTask?.cancel()

        guard let rightSearchName = searchName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://swapi.co/api/people/?search=\(rightSearchName)") else {
                print("wrong URl")
                return
        }
        var json: JSONDictionary?
        dataTask = session.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data else {
                return
            }
            do {
                json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            } catch let error as NSError {
                print(error.localizedDescription)
                return
            }

            guard let json = json,
                let results = json["results"] as? [JSONDictionary],
                let firstResult = results.first,
                let name = firstResult["name"] as? String else {
                    return
            }
            self?.updateMovies(firstResult)
            self?.group.notify(queue: DispatchQueue.main) {
                complition(self?.films, name)
            }
        }
        dataTask?.resume()
    }

    private func updateMovies(_ json: JSONDictionary) {
        films.removeAll()
        var filmsJSON: JSONDictionary?
        guard let films = json["films"] as? [String] else {
            return
        }
        for film in films {
            group.enter()
            guard let url = URL(string: film) else {
                return
            }
            session.dataTask(with: url) { [weak self]  data, _, error in
                guard let data = data else {
                    return
                }
                do {
                    filmsJSON = try (JSONSerialization.jsonObject(with: data, options: []) as? Networking.JSONDictionary)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                guard let filmsJSON = filmsJSON,
                    let title = filmsJSON["title"] as? String,
                    let date = filmsJSON["release_date"] as? String,
                    let releaseDate = formatter.date(from: date) else {
                        print("no title")
                        return
                }

                self?.films.append(Film(title: title, releaseDate: releaseDate))
                self?.group.leave()
            }.resume()
        }
    }
}
