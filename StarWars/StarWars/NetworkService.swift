import Foundation

final class NetworkService {
  var staff = PersonOfFilm()
  let queue = DispatchQueue.global()
  let session = URLSession.shared
  var dataTask: URLSessionDataTask?
    
    func downLoad(_ textForSearching: String, callback: @escaping (PersonOfFilm) -> Void) {
    guard let clearSearchText = textForSearching.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      let film = Film("Error", "Не правильный запрос")
      staff.arrayFilm.append(film)
        return
    }
    let url = URL(string: "https://swapi.co/api/people/?search=\(clearSearchText)")
    dataTask = session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
      guard let data = data else {
        return
      }
      let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
      if let failUpload = json["count"], let count = failUpload as? Int, count == 0 {
          let film = Film("Error", "Ничего не найдено")
        self?.staff.name = ":("
          self?.staff.arrayFilm.append(film)
        callback((self?.staff)!)
      } else { self?.parseJSON(json: json["results"] as! [[String: Any]])
            let downloadGroup = DispatchGroup()
            for i in (self?.staff.filmsURL)! {
                downloadGroup.enter()
                self?.uploadInfoFilms(i, callback: {
                    downloadGroup.leave()
                })
            }
            downloadGroup.notify(queue: .main, execute: {
                callback((self?.staff)!)
            })
        }
    })
    dataTask?.resume()
  }
  private func uploadInfoFilms(_ url: String, callback: @escaping () -> Void) {
      let url = URL(string: url)
      self.dataTask = self.session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
        guard let data = data else {
          return
        }
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? ["": 0]
        if let title = json["title"], let date = json["release_date"] {
          let film = Film(date as? String ?? "", title as? String ?? "")
          self?.staff.arrayFilm.append(film)
        }
        callback()
      })
      self.dataTask?.resume()
  }
    private func parseJSON(json: [[String: Any]]) {
        let results = json
        for result in results {
            staff.name = result["name"] as? String ?? ""
            staff.url = result["url"] as? String ?? ""
            staff.filmsURL = result["films"] as? [String] ?? []
        }
    }
}
