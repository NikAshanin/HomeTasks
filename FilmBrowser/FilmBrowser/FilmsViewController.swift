import UIKit

<<<<<<< HEAD
final class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeChangeProtocol {

  private let films = FilmBuilder.naiveGenerate()

  @IBOutlet private  weak var infoLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  func likeChange(_ index: Int) {
    films.changeLikes(index)
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return films.count()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FilmViewCell
    let film = films.get(index: indexPath.row)
    cell?.setImage(image: UIImage(named: film.urlImage))
    cell?.setFilmTitle(title: film.name)
    cell?.setLikesCount(likes: film.countLikes)

    return cell ?? UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
        as? DetailViewController
      else {
        return
    }
    detailViewController.likeChangeDelegate = self
    detailViewController.currentIndex = indexPath.row
    detailViewController.film = films.get(index: indexPath.row)

    navigationController?.pushViewController(detailViewController, animated: true)
  }
=======
final class FilmsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

>>>>>>> upstream/master
}
