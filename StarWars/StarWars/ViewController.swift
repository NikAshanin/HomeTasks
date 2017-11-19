import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var yearLabel: UILabel!
    private var movies: [Film] = []
    private let networking = Networking()
    private let reuseIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(movies[indexPath.row])
        let calendar = Calendar.current
        let year = calendar.component(.year, from: movies[indexPath.row].releaseDate)
        yearLabel.text = "Этот фильм вышел в \(year) году"
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.isEmpty {
            EmptyTableViewHelper().emptyViewWith(message: "There is no one.\nPlease search character from Star Wars",
                                                 tableView: tableView)
            return 0
        } else {
            tableView.backgroundView = nil
            return movies.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
            UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        movies.removeAll()
        tableView.reloadData()
        resignFirstResponder()
        print("start search")
        guard let text = textField.text,
        !text.isEmpty else {
            print("no text")
            return false
        }
        networking.getCharacter(text) { [weak self] films, name in
            if let films = films {
                self?.movies = films
                self?.title = name
                self?.tableView.reloadData()
            }
        }
        view.endEditing(true)
        return true
    }
}

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
