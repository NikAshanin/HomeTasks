import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var textField: UITextField!
    private var films: [Film] = []
    private let network = NetworkService()
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
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? CreateTableViewCell {
            cell.configure(name: films[indexPath.row].name)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(films[indexPath.row])
        let year = Calendar.current.component(.year, from: films[indexPath.row].date)
        let message = "Этот фильм вышел в \(year) году."
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        network.getJsonFromUrl(searchNameCharacter: text) { [weak self] films, name in
            self?.films = films
            self?.name.text = name
            DispatchQueue.main.sync {
            self?.tableView.reloadData()
            }
        }
        textField.text = ""
        view.endEditing(true)
        return true
    }
}
