import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var filmsTableView: UITableView!
    private let errorColor = #colorLiteral(red: 1, green: 0.5833955407, blue: 0.5876240134, alpha: 1), okColor = #colorLiteral(red: 0.722771585, green: 0.8874585032, blue: 0.5934467316, alpha: 1)
    fileprivate let networkService = NetworkService()
    fileprivate var films = [Film]()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            guard let text = searchTextField.text,
                !text.isEmpty else {
                    searchTextField.textColor = errorColor
                    return false
            }
            searchTextField.isUserInteractionEnabled = false
            releaseDateLabel.text = ""
            searchTextField.textColor = okColor
            films.removeAll()
            filmsTableView.reloadData()
            searchTextField.resignFirstResponder()
            updateFilmsList(characterName: text)
            return false
        }
        return true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = films[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = film.filmName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let film = films[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        guard let year = film.year else {
            let alert = UIAlertController(title: "Error", message: "No release year",
                                          preferredStyle: UIAlertControllerStyle.alert)
            present(alert, animated: true, completion: nil)
            return
        }
        releaseDateLabel.text = "This film was released in \(year)"
    }
}

fileprivate extension ViewController {

    func updateFilmsList(characterName: String) {
        networkService.getFilms(characterName: characterName) { [weak self] films in
            guard !films.isEmpty else {
                return }
            self?.films = films

            DispatchQueue.main.sync {
                self?.filmsTableView.reloadData()
                self?.searchTextField.isUserInteractionEnabled = true
            }
        }
    }

}
