import UIKit

final class FilmsViewController: UIViewController {

    fileprivate let filmModel = FilmModel()
    var filmLikes: [String: Int] = [:]

    @IBOutlet weak private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tableView.reloadData()
    }

    private func registerCells() {
        let nib = UINib(nibName: "FilmCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmCell.reuseId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filmSegue" {
            let vc = segue.destination as? DetailViewController

            guard let cell = sender as? FilmCell, let row = tableView.indexPath(for: cell)?.row else {
                return
            }

            let film = filmModel.films[row]

            vc?.delegate = self
            vc?.film = film
            vc?.likes = filmLikes[film.title] ?? 0
        }
    }
}

// MARK: - TableView Data Source

extension FilmsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmModel.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmCell.reuseId, for: indexPath) as? FilmCell else {
            return UITableViewCell()
        }

        let film = filmModel.films[indexPath.row]
        let likess = filmLikes[film.title] ?? 0

        cell.configure(film, likes: likess)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "filmSegue", sender: tableView.cellForRow(at: indexPath))
    }
}

// MARK: - Like Delegate

extension FilmsViewController: LikeDelegate {

    func plusOneLike(to film: String) {
        guard let likess = filmLikes[film] else {
            filmLikes[film] = 1
            return
        }

        filmLikes[film] = likess + 1
    }
}

protocol LikeDelegate: class {
    func plusOneLike(to film: String)
}
