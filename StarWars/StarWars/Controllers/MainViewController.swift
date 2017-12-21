import UIKit

final class MainViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var filmsTableView: UITableView!
    @IBOutlet private weak var filmYearLabel: UILabel!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    private let networkService = NetworkService()
    private var films = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()

        filmsTableView.delegate = self
        filmsTableView.dataSource = self
        searchTextField.delegate = self
        loaderActivityIndicator.stopAnimating()
        clearFilmYearLabel()
    }

    private func clearFilmYearLabel() {
        filmYearLabel.text = ""
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let year = films[indexPath.row].year
        filmYearLabel.text = "Этот фильм вышел в \(year) году"
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath)
        cell.textLabel?.text = films[indexPath.row].title
        return cell
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        films.removeAll()
        clearFilmYearLabel()
        filmsTableView.reloadData()
        guard let searchString = searchTextField.text, !searchString.isEmpty else {
            return false
        }
        loaderActivityIndicator.startAnimating()
        networkService.getCharacter(characterName: searchString) { [weak self] (_, films, errorString) in
            if let errorString = errorString {
                print(errorString)
            }
            if !films.isEmpty {
                self?.films = films
            } else {

            }
            self?.filmsTableView.reloadData()
            self?.loaderActivityIndicator.stopAnimating()
        }
        view.endEditing(true)
        return true
    }
}
