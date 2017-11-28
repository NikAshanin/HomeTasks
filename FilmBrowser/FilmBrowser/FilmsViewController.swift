import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    fileprivate let viewModel = InfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.cellIdentifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.films.count
    }
}
extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = FilmTableViewCell.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? FilmTableViewCell
        cell?.configure(film: viewModel.films[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = "DetailViewController"
        guard let view = storyboard?.instantiateViewController(withIdentifier: id) as? DetailViewController else {
            return
        }
        view.film = viewModel.films[indexPath.row]
        view.delegate = self
        navigationController?.pushViewController(view, animated: true)
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
