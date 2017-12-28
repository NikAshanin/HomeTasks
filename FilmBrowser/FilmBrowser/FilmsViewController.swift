import UIKit

final class FilmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var table: UITableView!
    let model = FilmModel()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FilmTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "Film")
            as? FilmTableViewCell else {
            fatalError("Wrong cell type.")
        }
        cell.film = model.films[indexPath.row]
        cell.set(title: model.films[indexPath.row].title,
                 image: model.films[indexPath.row].image,
                 likes: model.films[indexPath.row].likes,
                 defaultWidth: self.view.frame.size.width)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let detailViewController =
            storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
                as? DetailViewController else { return }
        let cell = tableView.cellForRow(at: indexPath) as? FilmTableViewCell
        detailViewController.delegate = cell
        detailViewController.film = model.films[indexPath.row]

        navigationController?.pushViewController(detailViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        let yourNibName = UINib(nibName: "Film", bundle: nil)
        table.register(yourNibName, forCellReuseIdentifier: "Film")
    }
}
