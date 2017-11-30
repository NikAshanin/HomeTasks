import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var yearLabel: UILabel!
    private var films: [Film] = []
    private let networking = Networking()
    private let message = "There is no one.\nPlease search character from Star Wars"
    private var emptyView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        emptyView = EmptyTableViewHelper.installEmptyView(in: tableView,
                                                          with: message)
        tableView.backgroundView = emptyView
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(films[indexPath.row])
        let year = BaseDateFormatter.getYear(from: films[indexPath.row].releaseDate)
        yearLabel.text = "Этот фильм вышел в \(year) году"
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if films.isEmpty {
            return 0
        } else {
            return films.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = films[indexPath.row].title
        return cell
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        films.removeAll()
        tableView.reloadData()
        print("start search")
        guard let searchString = textField.text,
        !searchString.isEmpty else {
            print("no searchString")
            return false
        }
        networking.searchCharacter(searchString) { [weak self] films, name in
            if let films = films, !films.isEmpty {
                self?.films = films
                self?.title = name
                print(films)
                self?.tableView.backgroundView = nil
                self?.tableView.reloadData()
            } else {
                print("no films")
                DispatchQueue.main.async {
                    self?.tableView.backgroundView = self?.emptyView
                    self?.tableView.reloadData()
                }
            }
        }
        view.endEditing(true)
        return true
    }
}
