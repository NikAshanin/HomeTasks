import UIKit

final class FilmsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var films = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "FilmTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "customCell")

        guard let file = Bundle.main.url(forResource: "data", withExtension: "json"),
            let data = try? Data(contentsOf: file),
            let films = try? JSONDecoder().decode([Film].self, from: data) else {
                return
            }

        self.films = films
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                return
        }

        destination.film = films[indexPath.row]
        destination.delegate = self
    }
}

extension FilmsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? FilmTableViewCell

        guard let myCell = cell else {
            return UITableViewCell()
        }

        myCell.film = films[indexPath.row]
        return myCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController"),
                let detail = viewController as? DetailViewController else {
            return
        }
        detail.film = films[indexPath.row]
        detail.delegate = self
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension FilmsViewController: DetailViewProtocol {

    func buttonPressed(_ film: Film) {
        guard let index = films.index(of: film) else {
            return
        }
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
