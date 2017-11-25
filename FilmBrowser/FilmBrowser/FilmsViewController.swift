import UIKit

final class FilmsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var films = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let file = Bundle.main.url(forResource: "source", withExtension: "txt"),
            let data = try? Data(contentsOf: file),
            let films = try? JSONDecoder().decode([Film].self, from: data) else {
                return
            }
        self.films = films
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                return
        }

        destination.film = films[indexPath.row]
        destination.index = indexPath.row
        destination.delegate = self
    }

}

extension FilmsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = (Bundle.main.loadNibNamed("FilmTableViewCell", owner: self, options: nil)?.first) as? FilmTableViewCell {
            cell.updateUI(filmData: films[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInfo", sender: self)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }

}

extension FilmsViewController: DetailViewProtocol {

    func buttonPressed(_ index: Int) {
        let ip = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [ip], with: .automatic)
    }

}
