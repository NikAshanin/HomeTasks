import UIKit
final class SearchViewController: UIViewController {
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var filmsTableView: UITableView!
    fileprivate let networkService = NetworkService()
    fileprivate var films = [Film]()

}

fileprivate extension SearchViewController {
    func updateFilmsList(characterName: String) {
        networkService.getFilms(characterName: characterName) { [weak self] films in
//             ИМХО через if тут было бы лучше сделать проверку
            guard !films.isEmpty else {
                DispatchQueue.main.sync {
                    self?.releaseDateLabel.isUserInteractionEnabled = true
                }
                return
            }
            self?.films = films

            DispatchQueue.main.sync {
                self?.filmsTableView.reloadData()
                self?.releaseDateLabel.isUserInteractionEnabled = true
            }
        }
    }
}
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            guard let text = searchTextField.text,
                !text.isEmpty else {
                    searchTextField.textColor = UIColor.error
                    return false
            }
            searchTextField.isUserInteractionEnabled = false
            releaseDateLabel.text = ""
            searchTextField.textColor = UIColor.ok
            films.removeAll()
            filmsTableView.reloadData()
            searchTextField.resignFirstResponder()
            updateFilmsList(characterName: text)
            return false
        }
        return true
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = films[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = film.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = films[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        guard film.year > 0 else {
            let alert = UIAlertController(title: "Error", message: "No release year",
                                          preferredStyle: UIAlertControllerStyle.alert)
            present(alert, animated: true, completion: nil)
            return
        }
        releaseDateLabel.text = "This film was released in \(film.year)"
    }
}
