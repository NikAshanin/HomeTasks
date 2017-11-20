import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField! { didSet { searchTextField.delegate = self } }
    
    private let urlTemplate = "https://swapi.co/api/people/?search="
    private let formatter = DateFormatter()
    private var allCharacters = [Character]()
    private var characters = [Character]()
    private var lastUrl: URL?
    
    private var url: URL? {
        var newUrl: URL?
        if let validSearchText = searchText?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            newUrl = URL(string: urlTemplate + String(validSearchText))
        }
        return newUrl
    }
    
    var searchText: String? {
        didSet {
            spinner.startAnimating()
            searchTextField.resignFirstResponder()
            dateLabel.text?.removeAll()
            characters.removeAll()
            tableView.reloadData()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.checkFetchedCharacters()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchCharacters() {
        lastUrl = url
        if let url = lastUrl {
            let session = URLSession(configuration: .default)
            let group = DispatchGroup()
            group.enter()
            let task  = session.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data,
                    let searchResult = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                    let characters = searchResult["results"] as? [[String: Any]] {
                    self?.allCharacters += characters.map { Character(info: $0) }
                }
                group.leave()
            }
            task.resume()
            group.wait()
        }
    }
    
    private func checkFetchedCharacters() {
        let countOfCharacters = getValidCharacters()
        if countOfCharacters == 0 {
            fetchCharacters()
            getValidCharacters()
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.spinner.stopAnimating()
        }
    }
    
    private func getValidCharacters() -> Int {
        characters = allCharacters.filter {character in
            if let searchText = searchText, character.name.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        }
        return characters.count
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
        let dateString = characters[indexPath.section].films[indexPath.row].1
        formatter.dateFormat = "yyyy-mm-dd"
        let data = formatter.date(from: dateString)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: data!)
        dateLabel.text = "Этот фильм вышел в \(year) году"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = textField.text
        }
        return true
    }
}
