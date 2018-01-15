import UIKit

final class InfoViewController: UIViewController {
    private let films = FilmBuilder.generateFilms()
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
}
extension InfoViewController: LikeChangeProtocol {
    func likeChange(_ filmName: String) {
        films.changeLikes(filmName)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let myCell = cell as? TableViewCell {
            let film = films.get(index: indexPath.row)
            myCell.pushDataToCell(film)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController
            else { return }
        detailViewController.delegate = self
        detailViewController.film = films.get(index: indexPath.row)
        detailViewController.currentIndex = indexPath.row
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
