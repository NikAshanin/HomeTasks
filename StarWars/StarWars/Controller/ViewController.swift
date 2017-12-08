import UIKit

final class ViewController: UIViewController {

    // MARK: - Properties

    private let dataManager = DataManager()

    // MARK: - Outlets

    @IBOutlet weak private var filmsTableView: UITableView!
    @IBOutlet weak private var filmYearLabel: UILabel!
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
        filmYearLabel.text = nil
        dataManager.films.removeAll()

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

        dataManager.loadFilmData(with: text) { films in
            self.dataManager.films = films
            self.updateUI()
        }

        return true
    }
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = dataManager.films[indexPath.row]
        if let cell = filmsTableView.dequeueReusableCell(withIdentifier: FilmTitleCell.reuseId) as? FilmTitleCell {

            cell.configure(film)

            return cell
        }

        return UITableViewCell()
    }
}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filmYearLabel.text = DataFormatterConfigurator.getYear(from: dataManager.films[indexPath.row].releaseDate)
    }
}
