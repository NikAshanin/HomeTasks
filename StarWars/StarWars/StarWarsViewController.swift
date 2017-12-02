import UIKit

final class StarWarsViewController: UIViewController {

    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField! { didSet { searchTextField.delegate = self } }

    private let urlTemplate = "https://swapi.co/api/people/?search="
    private let session = URLSession.shared
    private var heroes = [Hero]()

    private var url: URL? {
        if let validSearchText = searchText?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
             return URL(string: urlTemplate + String(validSearchText))
        }
        return nil
    }

    var searchText: String? {
        didSet {
            spinner.startAnimating()
            searchTextField.resignFirstResponder()
            dateLabel.text?.removeAll()
            heroes.removeAll()
            tableView.reloadData()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.fetchHeroes()
            }
        }
    }

    private func fetchHeroes() {
        guard let url = url else {
            return
        }
        var tempHeroes = [[String: Any]]()
        let group = DispatchGroup()
        group.enter()
        let task  = session.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                let heroesJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let heroes = heroesJson["results"] as? [[String: Any]] else {
                    return
            }
            tempHeroes = heroes
            group.leave()
        }
        task.resume()

        group.notify(queue: .global()) { [weak self] in
            let secondGroup = DispatchGroup()
            for hero in tempHeroes {
                secondGroup.enter()
                DispatchQueue.global().async {
                    guard let name = hero["name"] as? String,
                        let filmsUrl = hero["films"] as? [String],
                        let films = self?.fetchFilms(filmsUrl: filmsUrl) else {
                            return
                    }
                    self?.heroes.append(Hero(info: hero, name: name, films: films))
                    secondGroup.leave()
                }
            }
            secondGroup.notify(queue: .main) {
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }

    func fetchFilms(filmsUrl: [String]) -> [Film]? {
        var films = [Film]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        let group = DispatchGroup()
        for filmUrl in filmsUrl {
            guard let url = URL(string: filmUrl) else {
                continue
            }
            group.enter()
            let task = session.dataTask(with: url) { (data, _, _) in
                guard let data = data,
                    let filmJson = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                    let filmTitle = filmJson["title"] as? String,
                    let filmDate = filmJson["release_date"] as? String,
                    let date = formatter.date(from: filmDate) else {
                        return
                }
                films.append(Film(info: filmJson, title: filmTitle, date: date))

                group.leave()
            }
            task.resume()
        }
        group.wait()
        return films.isEmpty ? nil : films
    }
}

extension StarWarsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = textField.text
        }
        return true
    }
}

extension StarWarsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return heroes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes[section].films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)

        let allFilms = heroes[indexPath.section].films
        let film = allFilms[indexPath.row]
        cell.textLabel?.text = film.title

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return heroes[section].name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = heroes[indexPath.section].films[indexPath.row].date
        dateLabel.text = "Этот фильм вышел в \(date.year) году"
    }
}
