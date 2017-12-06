import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    fileprivate let filmsModel = FilmsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FilmTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: FilmTableViewCell.cellIdentifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsModel.films.count
    }
}
extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = FilmTableViewCell.cellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? FilmTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(film: filmsModel.films[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = "DetailViewController"
        guard let detailViewControl = storyboard?.instantiateViewController(withIdentifier: id) as? DetailViewController else {
            return
        }
        detailViewControl.film = filmsModel.films[indexPath.row]
        detailViewControl.delegate = self
        navigationController?.pushViewController(detailViewControl, animated: true)
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
