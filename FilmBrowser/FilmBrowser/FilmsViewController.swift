import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    fileprivate let viewModel = FilmsViewModel()

    private func registerCells() {
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.reuseId)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController else {
                return
        }
        detailViewController.delegate = self
        detailViewController.film = viewModel.films[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}

extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.reuseId,
                                                 for: indexPath) as? FilmTableViewCell
        guard let filmCell = cell else {
            return UITableViewCell()
        }
        let film = viewModel.films[indexPath.row]
        filmCell.configure(film)
        return filmCell
    }
}

extension FilmsViewController: LikeProtocol {
    func like(_ film: Film) {
        film.likes += 1
        tableView.reloadData()
    }
}

protocol LikeProtocol: class {
    func like(_ film: Film)
}
