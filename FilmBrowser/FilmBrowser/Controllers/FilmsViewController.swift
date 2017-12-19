import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!

    fileprivate let filmsSource = FilmSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.reuseId)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsSource.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.reuseId,
                                                 for: indexPath)
        if let filmCell = cell as? FilmTableViewCell {
            filmCell.configure(filmsSource.films[indexPath.row])
            return filmCell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier:
     "DetailViewController") as? DetailViewController else {
            return
        }
        detailViewController.delegate = self
        detailViewController.film = filmsSource.films[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FilmsViewController: LikesProtocol {
    func addLike(film: Film) {
        film.likes += 1
        tableView.reloadData()
    }
}
