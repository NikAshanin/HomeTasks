import UIKit

final class ViewController: UIViewController {

    // MARK: - Properties

    private let dataManager = DataManager()
    private var films = [FilmsModel]()

    // MARK: - Outlets

    @IBOutlet weak private var filmsTableView: UITableView!
    @IBOutlet weak private var filmYear: UILabel!
    @IBOutlet weak private var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        searchTextField.delegate = self
    }

    private func registerCells() {
        let nib = UINib(nibName: "FilmTitleCell", bundle: Bundle.main)
        filmsTableView.register(nib, forCellReuseIdentifier: FilmTitleCell.reuseId)
    }

    private func updateUI() {
        filmsTableView.reloadData()
    }

    private func clearTableView() {
        filmYear.text = nil
        films.removeAll()

        updateUI()
    }
}

// MARK: - Text Field Delegate

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text else {
            return false
        }

        clearTableView()

        dataManager.loadData(with: text) { films in
            self.films = films
            self.updateUI()
        }

        return true
    }
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = films[indexPath.row]
        guard let cell = filmsTableView.dequeueReusableCell(withIdentifier: FilmTitleCell.reuseId) as? FilmTitleCell else {
            return UITableViewCell()
        }

        cell.configure(film)

        return cell
    }
}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filmYear.text = DataFormatterConfigurator.getYear(from: films[indexPath.row].releaseDate)
    }
}
