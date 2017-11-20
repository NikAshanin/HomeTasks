import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField! { didSet { searchTextField.delegate = self } }
    
    private var characters = [Character]()
    private var url: URL = URL(string: "https://swapi.co/api/people/?page=1")!
    private let formatter = DateFormatter()
    
    var searchText: String? {
        didSet {
            searchTextField.resignFirstResponder()
            characters.removeAll()
            fetchCharacters()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchCharacters() {
        let session = URLSession(configuration: .default)
        let task  = session.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data,
                let pageJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let characters = pageJson["results"] as? [[String: Any]] {
                self?.characters = characters.map { Character(info: $0) }
                self?.searchCharacter()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    private func searchCharacter() {
        characters = characters.filter {character in
            if let searchText = searchText, character.name.contains(searchText) {
                return true
            }
            return false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters[section].films.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
     
        let films = characters[indexPath.section].films
        let filmName = films[indexPath.row]
        cell.textLabel?.text = filmName.0
     
        return cell
     }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return characters[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dateString = characters[indexPath.section].films[indexPath.row].1
        formatter.dateFormat = "yyyy-mm-dd"
        let data = formatter.date(from: dateString)
        formatter.dateFormat = "MMM d, yyyy"
        dateString = formatter.string(from: data!)
        dateLabel.text = dateString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = textField.text
        }
        return true
    }
}
