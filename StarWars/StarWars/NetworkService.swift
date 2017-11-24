import Foundation



final class NetworkService{
  var staff = Staff()
  let queue = DispatchQueue.global()
  let session = URLSession.shared
  var dataTask: URLSessionDataTask?
  
  func downLoad(_ textForSearching: String, callback: @escaping (Staff) -> Void)  {
    guard let clearSearchText = textForSearching.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      let film = Film("Error", "Не правильный запрос")
      staff.arrayFilm.append(film)
      //return callback
        return
    }
    let url = URL(string: "https://swapi.co/api/people/?search=\(clearSearchText)")
    dataTask = session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
      guard let data = data else {
        return
      }
      let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
      if let failUpload = json["count"] {
        if let count = failUpload as? Int, count == 0 {
          let film = Film("Error", "Ничего не найдено")
          self?.staff.arrayFilm.append(film)
          
        } else if let results = json["results"] as? [[String: Any]] {
          for result in results {
            self?.staff.name = result["name"] as! String
            self?.staff.url = result["url"] as! String
            self?.staff.filmsURL = result["films"] as! [String]
          }
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
      }
    })
    dataTask?.resume()
    //return staff
  }
  func uploadInfoFilms(_ url: String, callback: @escaping () -> Void) {

      let url = URL(string: url)
      self.dataTask = self.session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
        guard let data = data else {
          return
        }
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if let title = json["title"], let date = json["release_date"] {
          let film = Film.init(date as! String, title as! String)
          self?.staff.arrayFilm.append(film)
        }
        callback()
      })
    
      self.dataTask?.resume()
  }
}
