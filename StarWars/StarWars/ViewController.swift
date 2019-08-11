import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    
    private var films: [Film] = []
    private let reuseIdentifier = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: films[indexPath.row].dateOfFilm)
        yearLabel.text = "This film was relased in \(year)"
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = self.films[indexPath.row].nameOfFilm
        
        return cell
    }
    
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        self.films.removeAll()
        let json = JsonDownload()
        json.downloadJSON(searchName:text) { [weak self] films in
            print(films)
            self?.films = films
            self?.tableView.reloadData()
        }
        return true
    }
}
let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-mm-dd"
    return formatter
}()


