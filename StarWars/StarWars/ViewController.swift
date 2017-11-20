import UIKit

final class ViewController: UIViewController{
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var dateOfFilmLabel: UILabel!
    @IBOutlet weak var nameStaffLabel: UILabel!
    var staff = Staff(name: "", url: "", filmsURL: [], arrayFilm: [])
//    let dateformatter = DateFormatter()
    let queue = DispatchQueue.global()
    let downloadGroup = DispatchGroup()
    override func viewDidLoad() {
      super.viewDidLoad()
      dateOfFilmLabel.isHidden = true
    }
    @IBAction func startSearch(_ sender: Any) {
      staff.arrayFilm = []
      tableView.reloadData()
      downLoad()
    }
}
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.resignFirstResponder()
    return true
  }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return staff.arrayFilm.isEmpty ? 1 : staff.arrayFilm.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    staff.arrayFilm.isEmpty ? (cell.textLabel?.text = "") : (cell.textLabel?.text = staff.arrayFilm[indexPath.row].title)
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard staff.arrayFilm[indexPath.row].date != "Error" else{
      return
    }
    dateOfFilmLabel.isHidden = false
    let year = ModifyDate().cutYear(date: staff.arrayFilm[indexPath.row].date)
    self.dateOfFilmLabel.text = "Фильм вышел: \(year)"
  }
}
extension ViewController{
  func downLoad(){
    let session = URLSession.shared
    var dataTask: URLSessionDataTask?
    guard let clearSearchText = searchTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
      return
    }
    let url = URL(string: "https://swapi.co/api/people/?search=\(clearSearchText)")
    dataTask = session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
      guard let data = data else{
        return
      }
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if let failUpload = json["count"] {
          if let count = failUpload as? Int, count == 0{
            let film = Film.init("Error", "Ничего не найдено")
            self?.staff.arrayFilm.append(film)
            DispatchQueue.main.async {
              self?.tableView.reloadData()
              self?.nameStaffLabel.text = ":(("
            }
          } else if let results = json["results"] as? [[String: Any]]{
              for result in results{
                self?.staff.name = result["name"] as! String
                self?.staff.url = result["url"] as! String
                self?.staff.filmsURL = result["films"] as! [String]
              }
              for i in (self?.staff.filmsURL)! {
                self?.uploadInfoFilms(i)
              }
            }
        }
    })
    dataTask?.resume()
  }
  
  func uploadInfoFilms(_ url: String){
    queue.async {
      let session = URLSession.shared
      var dataTask: URLSessionDataTask?
      let url = URL(string: url)
      self.downloadGroup.enter()
      dataTask = session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
        guard let data = data else {
          return
        }
          let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
          if let title = json["title"], let date = json["release_date"] {
            let film = Film.init(date as! String, title as! String)
            self?.staff.arrayFilm.append(film)
          }
        self?.downloadGroup.leave()
      })
      dataTask?.resume()
      self.downloadGroup.wait()
      DispatchQueue.main.sync {
        self.tableView.reloadData()
        self.nameStaffLabel.text = self.staff.name
      }
    }
  }
}
