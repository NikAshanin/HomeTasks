import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    private var films: [NameFilmWithDate] = []
    private let information = GetInformationNet()
    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let w = 1 - scrollView.contentOffset.y / scrollView.contentSize.height
        view.backgroundColor = UIColor(white: w, alpha: 1)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as? CreateTableViewCell
        cell?.nameLabel.text = films[indexPath.row].nameFilm
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(films[indexPath.row])
        let alert = UIAlertController(title: "", message: films[indexPath.row].dateFilm, preferredStyle: UIAlertControllerStyle.alert)
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

