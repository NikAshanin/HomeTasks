import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    fileprivate let filmsModel = FilmsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.cellIdentifier)
    }
}

extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsModel.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.cellIdentifier, for: indexPath)
        if let cell = cell as? FilmTableViewCell {
            cell.configure(film: filmsModel.films[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController else {
            return
        }
        detailViewController.film = filmsModel.films[indexPath.row]
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension FilmsViewController: LikeChangeProtocol {
    func likeChange(film: Film) {
        film.likeCount += 1
        tableView.reloadData()
    }
}
