import UIKit

class InfoViewController: UIViewController {
  let films = FilmBuilder.naviGenerate()
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 100
  }
}
extension InfoViewController: LikeChangeProtocol {
  func likeChange(_ index: Int) {
    films.changeLikes(index)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
    let film = films.get(index: indexPath.row)
    cell?.titleFilmLabel.text = film.name
    cell?.countLikesLabel.text = String(film.countLikes)
    cell?.imageFilm.image = UIImage(named: film.urlImage)
    return cell ?? UITableViewCell()
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
      else { return }
    detailViewController.delegate = self
    detailViewController.film = films.get(index: indexPath.row)
    detailViewController.currentIndex = indexPath.row
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

