import UIKit

final class StarWarsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var spinner: UIActivityIndicatorView!

    private let networkService = NetworkService()
    private var personageArray = [Personage]()
}

extension StarWarsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text, !text.isEmpty else {
            return false
        }
        spinner.startAnimating()
        searchTextField?.resignFirstResponder()
        personageArray.removeAll()
        tableView.reloadData()
        title = text
        networkService.searchFilmsLinks(searchText: text) { [weak self] personageArray in
            self?.personageArray = personageArray
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
        return true
    }
}

extension StarWarsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return personageArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personageArray[section].films.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return personageArray[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let films = personageArray[indexPath.section].films
        let film = films[indexPath.row]
        cell.textLabel?.text = film.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let date = personageArray[indexPath.section].films[indexPath.row].year else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "",
                                      message: "Этот фильм вышел в \(date) году.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Окей", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
