import UIKit

final class FilmsViewController: UIViewController {

    fileprivate let filmModel = FilmModel()
    //var filmLikes: [String: Int] = [:]

    @IBOutlet weak private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func registerCells() {
        let nib = UINib(nibName: "FilmCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmCell.reuseId)
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

        cell.configure(film)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "detail") as?
            DetailViewController else {
            return
        }
        detailViewController.delegate = self
        detailViewController.film = filmModel.films[indexPath.row]
        detailViewController.filmIndex = indexPath.row
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - Like Delegate

extension FilmsViewController: LikeDelegate {

    func plusOneLike(toFilmAt index: Int) {
        filmModel.films[index].likesCount += 1

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

protocol LikeDelegate: class {
    func plusOneLike(toFilmAt index: Int)
}
