import UIKit

final class FilmsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var filmsList = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()
        FilmSources.fetchDescriptions()
        filmsList = [
            Film(poster: #imageLiteral(resourceName: "E_1.jpg"), title: FilmSources.E1Title, descr: FilmSources.descriptions[0], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_2.jpg"), title: FilmSources.E2Title, descr: FilmSources.descriptions[1], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_3.jpg"), title: FilmSources.E3Title, descr: FilmSources.descriptions[2], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_4.jpg"), title: FilmSources.E4Title, descr: FilmSources.descriptions[3], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_5.jpg"), title: FilmSources.E5Title, descr: FilmSources.descriptions[4], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_6.jpg"), title: FilmSources.E6Title, descr: FilmSources.descriptions[5], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_7.jpg"), title: FilmSources.E7Title, descr: FilmSources.descriptions[6], likes: 0),
            Film(poster: #imageLiteral(resourceName: "E_8.jpg"), title: FilmSources.E8Title, descr: FilmSources.descriptions[7], likes: 0)
        ]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                return
        }

        destination.film = filmsList[indexPath.row]
        destination.index = indexPath.row
        destination.delegate = self
    }

}

extension FilmsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = (Bundle.main.loadNibNamed("FilmTableViewCell", owner: self, options: nil)?.first) as? FilmTableViewCell {
            cell.filmData = filmsList[indexPath.row]
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
