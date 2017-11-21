import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField! { didSet { searchTextField.delegate = self } }

    private let urlTemplate = "https://swapi.co/api/people/?search="
    private let formatter = DateFormatter()
    private var characters = [Character]()

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
                self?.fetchCharacters()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func fetchCharacters() {
        if let url = url {
            let group = DispatchGroup()
            let session = URLSession.shared
            group.enter()
            let task  = session.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data,
                    let searchResult = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                    let characters = searchResult["results"] as? [[String: Any]] {
                    self?.characters = characters.map { Character(from: $0) }
                }
                group.leave()
            }
            task.resume()
            group.notify(queue: .global()) { [weak self] in
                self?.characters.forEach { character in
                    character.fetchFilms()
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            }
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
        let dateString = characters[indexPath.section].films[indexPath.row].1
        formatter.dateFormat = "yyyy-mm-dd"
        guard let data = formatter.date(from: dateString) else {
            return
        }
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: data)
        dateLabel.text = "Этот фильм вышел в \(year) году"
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = textField.text
        }
        return true
    }
}
