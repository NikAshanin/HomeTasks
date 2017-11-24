import UIKit

final class FilmsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let filmsList = [
    Film(poster: #imageLiteral(resourceName: "E_1.jpg"), title: FilmSources.E_1Title, descr: FilmSources.E_1Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_2.jpg"), title: FilmSources.E_2Title, descr: FilmSources.E_2Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_3.jpg"), title: FilmSources.E_3Title, descr: FilmSources.E_3Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_4.jpg"), title: FilmSources.E_4Title, descr: FilmSources.E_4Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_5.jpg"), title: FilmSources.E_5Title, descr: FilmSources.E_5Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_6.jpg"), title: FilmSources.E_6Title, descr: FilmSources.E_6Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_7.jpg"), title: FilmSources.E_7Title, descr: FilmSources.E_7Description, likes: 0),
    Film(poster: #imageLiteral(resourceName: "E_8.jpg"), title: FilmSources.E_8Title, descr: FilmSources.E_8Description, likes: 0),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {
                return
        }
        
        destination.film = filmsList[indexPath.row]
        destination.index = indexPath.row
        destination.delegate = self
    }
    
}

extension FilmsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FilmTableViewCell", owner: self, options: nil)?.first as! FilmTableViewCell
        
        cell.filmData = filmsList[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInfo", sender: self)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    
}

extension FilmsViewController: DetailViewProtocol {
    
    func buttonPressed(_ index: Int) {
        let ip = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [ip], with: .automatic)
    }
    
}
