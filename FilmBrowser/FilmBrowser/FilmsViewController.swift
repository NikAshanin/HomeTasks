import UIKit

final class FilmViewControler: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    fileprivate let viewModel = FilmViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func registerCells() {
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.reuseId)
    }

    private func getFilmDescription(_ filmIndex: Int) -> String {
        guard let fileURLProject = Bundle.main.path(forResource: "FilmsDescriptions", ofType: "txt") else {
            return "error"
        }
        let descriptions = try? String(contentsOfFile: fileURLProject, encoding: String.Encoding.utf8)
        let arrayOfDescriptions = descriptions?.components(separatedBy: "//") ?? [""]
        return arrayOfDescriptions[filmIndex]
    }
}

extension FilmViewControler: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.film.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmTableViewCell",
                                                 for: indexPath)
        let film = viewModel.film[indexPath.row]
        if let filmCell = cell as? FilmTableViewCell {
            filmCell.configure(film)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(
            withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailViewController.delegate = self
        detailViewController.currentFilm  = viewModel.film[indexPath.row]
        detailViewController.filmDescription = getFilmDescription(indexPath.row)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FilmViewControler: LikesChangeProtocol {
    func likesChange() {
        tableView.reloadData()
    }
}
