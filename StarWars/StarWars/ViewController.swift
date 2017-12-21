import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var nameLabel: UILabel!
    private var films: [SwapiData] = []
    private let webInfo = NetworkService()
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        films.removeAll()
        tableView.reloadData()
        guard let inputText = textField.text,
            !inputText.isEmpty else {
                return true
        }
        webInfo.getJson(searchName: inputText) { [weak self] results, name in
            DispatchQueue.main.async {
                self?.films = results
                self?.nameLabel.text = name
                self?.tableView.reloadData()
            }
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
                                                 for: indexPath)
        let filmName = films[indexPath.row].name
        cell.textLabel?.text = filmName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let date = films[indexPath.row].year else {
            return
        }
        let alert = UIAlertController(title: "",
                                      message: "Этот фильм вышел в \(date) году.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
