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
        detailViewController.filmInCell  = viewModel.film[indexPath.row]
        detailViewController.cellIndex = indexPath.row
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FilmViewControler: LikesChangeProtocol {
    func likesChangeAt(_ selectedCell: Int) {
        viewModel.film[selectedCell].likesCount += 1
        tableView.reloadData()
    }
}
