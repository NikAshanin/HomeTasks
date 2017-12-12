import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var name: UILabel!
    private var  films: [SwapiData] = []
    private let webInfo = NetworkService()
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        films.removeAll()
        tableView.reloadData()
        guard let inputText = textField.text,
            !inputText.isEmpty else {
                return false
        }
        webInfo.getJson(searchName: inputText) { [weak self] results, name in
            self?.films = results
            self?.name.text = name
            self?.tableView.reloadData()
        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as? CreateTableViewCell
        cell?.setLabelName(name: films[indexPath.row].name)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = films[indexPath.row].date.index(films[indexPath.row].date.startIndex, offsetBy: 4)
        let alert = UIAlertController(title: "", message:
            "Этот фильм вышел в \(films[indexPath.row].date.prefix(upTo: index)) году",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
