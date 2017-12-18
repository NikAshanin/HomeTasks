import UIKit

final class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var yearLabel: UILabel!

    private let service = APIService()
    private var characters = [Character]()
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text, !text.isEmpty else {
            return false
        }
        searchTextField.resignFirstResponder()
        characters.removeAll()
        tableView.reloadData()
        service.searchCharacters(searchText: text) { [weak self] foundCharacters in
            self?.characters = foundCharacters
            self?.service.fetchFilms(personages: foundCharacters) { [weak self] in
                self?.tableView.reloadData()
            }
        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters[section].films.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return characters[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let films = characters[indexPath.section].films
        let film = films[indexPath.row]
        cell.textLabel?.text = film.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let year = characters[indexPath.section].films[indexPath.row].year,
            let name = characters[indexPath.section].films[indexPath.row].name else {
                return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        yearLabel.text = "\(name) вышел в \(year) году"
    }
}
