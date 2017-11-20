import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var serachTextField: UITextField!
    @IBOutlet weak private var dateOfFilmLabel: UILabel!
  @IBOutlet weak var nameStaffLabel: UILabel!
  var staff = Staff.init(name: "", filmsURL: [], url: "", filmsName: [], filmDate: [])
    let downloadGroup = DispatchGroup()
    let queue = DispatchQueue.global()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      serachTextField.delegate = self
      dateOfFilmLabel.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if staff.filmsURL.isEmpty{ return 1
      } else { return staff.filmsName.count }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      if staff.filmsURL.isEmpty{
        cell.textLabel?.text = ""
      } else{
        cell.textLabel?.text = staff.filmsName[indexPath.row]
      }
      return cell
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      dateOfFilmLabel.isHidden = false
      let dateformatter = DateFormatter()
      dateformatter.dateFormat = "yyyy-MM-dd"
      let date = dateformatter.date(from: staff.filmDate[indexPath.row])
      let calendar = Calendar.current
      let year = calendar.component(.year, from: date!)
      self.dateOfFilmLabel.text = "Фильм вышел: \(year)"
  }
    @IBAction func startSearch(_ sender: Any) {
      staff.filmsName = []
      tableView.reloadData()
      uploadInfo()
    }
}



extension ViewController{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.serachTextField.resignFirstResponder()
    return true
  }
}

extension ViewController{
  func uploadInfo(){
    let session = URLSession.shared
    var dataTask: URLSessionDataTask?
    guard let clearSearchText = serachTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
      return
    }
    let url = URL(string: "https://swapi.co/api/people/?search=\(clearSearchText)")
    dataTask = session.dataTask(with: url!, completionHandler: {[weak self] data, _, _ in
      if let data = data {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if let failUpload = json["count"] {
          if let count = failUpload as? Int, count == 0{ // Как лучше это записать, чтобы избежать ворнинга?
            self?.staff.filmsName = ["Ничего не найдено"]
            DispatchQueue.main.async {
              self?.tableView.reloadData()
              self?.nameStaffLabel.text = ":(("
            }
          } else {
            if let results = json["results"] as? [[String: Any]]{
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
        if let data = data {
          let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
          if let title = json["title"], let date = json["release_date"] {
            self?.staff.filmsName.append(title as! String)
            self?.staff.filmDate.append(date as! String)
          }
          self?.downloadGroup.leave()
        }
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
