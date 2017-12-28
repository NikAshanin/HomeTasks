import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var textFilm: UITextField!
    @IBOutlet weak private var date: UILabel!
    let network: Network = Network()
    let url: String = "https://swapi.co/api/people/"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textFilm.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return network.filmsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FilmTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FilmTableViewCell else {
            fatalError("Wrong cell type.")
        }
        cell.setTitle(title: network.filmsArray[indexPath.row].title)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = network.filmsArray[indexPath.row].year
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        self.date.text = dateString
    }

    @IBAction func editingDidEnd(_ sender: Any) {
        guard let personName = textFilm.text else {
            return
        }
        self.date.text = "Loading..."
        network.getDataFrom(url, with: personName)
        network.dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.date.text = ""
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
