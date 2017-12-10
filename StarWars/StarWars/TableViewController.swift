import UIKit

class TableViewController: UITableViewController, UITextFieldDelegate {
    private let blankURL = "https://swapi.co/api/people/?search="
    private let session = URLSession.shared
    private var personageArray = [Personage]()
    private var searchText: String? {
        didSet {
            spinner.startAnimating()
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            personageArray.removeAll()
            tableView.reloadData()
            title = searchText
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.searchFilmsLinks()
            }
        }
    }

    @IBOutlet weak private var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }

    @IBOutlet weak private var spinner: UIActivityIndicatorView!

    private var url: URL? {
        if let validSearchText = searchText?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: blankURL + String(validSearchText))
        }
        return nil
    }

    private func searchFilmsLinks() {
        guard let url = url else {
            return
        }
        var variableJson = [[String: Any]]()
        let group = DispatchGroup()
        group.enter()
        let task = session.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                let personageJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let personages = personageJson["results"] as? [[String: Any]] else {
                    return
            }
            variableJson = personages
            group.leave()
        }
        task.resume()
        group.notify(queue: .global()) { [weak self] in
            let anotherGroup = DispatchGroup()
            for personage in variableJson {
                anotherGroup.enter()
                DispatchQueue.global().async {
                    guard let name = personage["name"] as? String,
                        let filmsUrl = personage["films"] as? [String],
                        let films = self?.fetchFilms(filmsUrl: filmsUrl) else {
                            return
                    }
                    self?.personageArray.append(Personage(personage: name, starredInFilms: films))
                    anotherGroup.leave()
                }
            }
            anotherGroup.notify(queue: .main) {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }

    func fetchFilms(filmsUrl: [String]) -> [Film]? {
        var films = [Film]()
        let group = DispatchGroup()
        for filmURL in filmsUrl {
            guard let url = URL(string: filmURL) else {
                continue
            }
            group.enter()
            let task = session.dataTask(with: url) { (data, _, _) in
                guard let data = data,
                    let filmJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                    let name = filmJson["title"] as? String,
                    let year = filmJson["release_date"] as? String else {
                        return
                }
                films.append(Film(filmName: name, filmedIn: year))
                group.leave()
            }
            task.resume()
        }
        group.wait()
        return films.isEmpty ? nil : films
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = textField.text
        }
        return true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return personageArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personageArray[section].films.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return personageArray[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let films = personageArray[indexPath.section].films
        let film = films[indexPath.row]
        cell.textLabel?.text = film.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = personageArray[indexPath.section].films[indexPath.row].year
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "",
                                      message: "Фильм вышел в \(date) году.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Окей", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
