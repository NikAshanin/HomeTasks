import UIKit

final class FilmsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    fileprivate let films = InfoViewModel.filmsFromBundle()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCell()
        title = "Films"
    }

    private func loadCell() {
        let cellNib = UINib(nibName: FilmTableViewCell.reuseId, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: FilmTableViewCell.reuseId)
    }
}

extension FilmsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.reuseId, for: indexPath)
            as? FilmTableViewCell
        guard let filmCell = cell else {
            return UITableViewCell()
        }
        filmCell.configure(films[indexPath.row])
        return filmCell
    }

}

extension FilmsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: films[indexPath.row].image) else {
            return 44
        }
        let aspectRatio = image.size.width / image.size.height
        let height = tableView.bounds.width / 2 / aspectRatio
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: DetailViewController.storyboardID)
            as? DetailViewController else {
            return
        }
        detailVC.delegate = self
        detailVC.film = films[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FilmsViewController: LikeDelegate {
    func like(film: Film) {
        print("like")
        film.likes += 1
        print(film.likes)
        tableView.reloadData()
    }
}
