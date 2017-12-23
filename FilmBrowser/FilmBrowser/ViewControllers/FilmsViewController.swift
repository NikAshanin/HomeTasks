import UIKit

final class FilmsViewController: UIViewController {

    @IBOutlet fileprivate weak var filmsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }

    private func registerCell() {
        let cellNib = UINib(nibName: FilmTableViewCell.reuseId, bundle: nil)
        filmsTableView.register(cellNib, forCellReuseIdentifier: FilmTableViewCell.reuseId)
    }
}

extension FilmsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilmsInfoHelper.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.reuseId, for: indexPath)

        if let filmCell = cell as? FilmTableViewCell {
            filmCell.updateUI(film: FilmsInfoHelper.films[indexPath.row])
        }
        return cell
    }
}

extension FilmsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: FilmInfoViewController.storyboardId)
        guard let filmInfoViewController = vc as? FilmInfoViewController else {
            return
        }
        filmInfoViewController.likeDelegate = self
        filmInfoViewController.film = FilmsInfoHelper.films[indexPath.row]
        navigationController?.pushViewController(filmInfoViewController, animated: true)
    }
}

extension FilmsViewController: LikeDelegate {
    func like() {
        filmsTableView.reloadData()
    }
}
