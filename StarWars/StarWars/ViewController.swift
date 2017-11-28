import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var textField: UITextField!
    private var films: [Film] = []
    private let information = NetworkService()
    @IBOutlet weak private var name: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as? CreateTableViewCell
        cell?.configure(name: "films[indexPath.row].nameFilm")
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(films[indexPath.row])
        let year = Calendar.current.component(.year, from: films[indexPath.row].dateFilm)
        let message = "Этот фильм вышел в \(year) году."
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        films.removeAll()
        tableView.reloadData()
        resignFirstResponder()
        guard let text = textField.text,
            !text.isEmpty else {
                return false
        }
        information.getJsonFromUrl(searchNameCharacter: text) { [weak self] films, name in
            self?.films = films
            self?.name.text = name
            self?.tableView.reloadData()
        }
        textField.text = ""
        view.endEditing(true)
        return true
    }
}

let formatting: DateFormatter = {
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format
}()
