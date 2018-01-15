import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var dateOfFilmLabel: UILabel!
    @IBOutlet weak private var nameStaffLabel: UILabel!
    private var staff = PersonOfFilm()
    private let network = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateOfFilmLabel.isHidden = true
    }
    @IBAction private func startSearch(_ sender: Any) {
        staff.arrayFilm = []
        network.downLoad(searchTextField.text ?? "") {[weak self] staff in
            self?.staff = staff
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.nameStaffLabel.text = self?.staff.name
            }
        }
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staff.arrayFilm.isEmpty ? 1 : staff.arrayFilm.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        staff.arrayFilm.isEmpty ? (cell.textLabel?.text = "") : (cell.textLabel?.text = staff.arrayFilm[indexPath.row].title)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dateOfFilmLabel.isHidden = false
        let year = String(describing: ModifyDate.getYear(date: staff.arrayFilm[indexPath.row].date))
        dateOfFilmLabel.text = "Фильм вышел: \(year)"
    }
}
