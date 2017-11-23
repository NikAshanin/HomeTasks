import Foundation

final class NetworkService{
  var staff = Staff()
  let queue = DispatchQueue.global()
  let session = URLSession.shared
  var dataTask: URLSessionDataTask?
  
  func downLoad(_ textForSearching: String) -> Staff {
    print(staff)

    guard let clearSearchText = textForSearching.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      let film = Film("Error", "Не правильный запрос")
      staff.arrayFilm.append(film)
      return staff
    }
    let url = URL(string: "https://swapi.co/api/people/?search=\(clearSearchText)")
    print("URL: \(url)")
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
            print(result["name"])
            print(result["url"])
            print(result["films"])
            self?.staff.name = result["name"] as! String
            self?.staff.url = result["url"] as! String
            self?.staff.filmsURL = result["films"] as! [String]
            print(self?.staff.name)
          }
          print(self?.staff.name)
          let downloadGroup = DispatchGroup()
          for i in (self?.staff.filmsURL)! {
            downloadGroup.enter()
            self?.uploadInfoFilms(i, callback: {
              downloadGroup.wait()
              
              downloadGroup.leave()
            })
            downloadGroup.wait()
          }
        }
      }
    })
    dataTask?.resume()
    return staff
  }
  func uploadInfoFilms(_ url: String, callback: @escaping () -> Void) {
    callback()
    queue.async {
      let url = URL(string: url)
      //      downloadGroup.enter()
      self.dataTask = self.session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
        guard let data = data else {
          return
        }
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if let title = json["title"], let date = json["release_date"] {
          let film = Film.init(date as! String, title as! String)
          self?.staff.arrayFilm.append(film)
        }
        //        downloadGroup.leave()
      })
      self.dataTask?.resume()
      
      //      DispatchQueue.main.async {
      //        self.tableView.reloadData()
      //        self.nameStaffLabel.text = self.staff.name
      //      }
    }
  }
}
