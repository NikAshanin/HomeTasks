import UIKit

final class FilmViewControler: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    fileprivate let viewModel = FilmViewModel()
    fileprivate let filmTableViewCell = FilmTableViewCell()
    private var selectedCell = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    private func registerCells() {
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.reuseId)
    }
}

extension FilmViewControler: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.film.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.reuseId,
                                                 for: indexPath) as? FilmTableViewCell
        guard let filmCell = cell else {
            return UITableViewCell()
        }
        let film = viewModel.film[indexPath.row]
        filmCell.configure(film)
        return filmCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(
            withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailViewController.delegate = self
        selectedCell = indexPath.row
        detailViewController.likesCount = viewModel.film[selectedCell].likesCount
        detailViewController.photoName = viewModel.film[selectedCell].photo
        detailViewController.filmTitle = viewModel.film[selectedCell].name
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FilmViewControler: LikesChangeProtocol {
    func likesChange(_ value: String) {
        viewModel.film[selectedCell].likesCount += 1
        self.tableView.reloadData()
    }
}
