import UIKit

final class FilmsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var films: [FilmObject] = InfoViewModel().filmsGet()
    let cellIdentifier = "cell"
    var flagRow = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "FilmTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
}
extension FilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilmTableViewCell
        cell?.configure(film: films[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailViewController.film = films[indexPath.row]
        detailViewController.delegate = self
        flagRow = indexPath.row
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
}
extension FilmsViewController: TextChangeProtocol {
    func textChange(_ value: Int) {
        films[flagRow].likeCount = value
        tableView.reloadData()
    }
}
