import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate let viewModel = InfoViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FilmTableViewCell", bundle: nil), forCellReuseIdentifier: FilmTableViewCell.cellIdentifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.films.count
    }
}
extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.cellIdentifier, for: indexPath) as? FilmTableViewCell
        cell?.configure(film: viewModel.films[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.film = viewModel.films[indexPath.row]
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension FilmsViewController: TextChangeProtocol {
    func textChange() {
        tableView.reloadData()
    }
}
