import UIKit

final class FilmsViewController: UIViewController, UICollectionViewDataSource,
        UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var filmsCollectionView: UICollectionView!
    private var films = [Film]()
    private var indexOfChoosenCell = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewPreparation()
        getFilms()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FilmTableViewCell
            else {
                return UICollectionViewCell() }
        cell.setFilmInfo(films[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController"),
        let detailViewController = newViewController as? DetailViewController else {
            return
        }
        indexOfChoosenCell = indexPath.item
        detailViewController.film = films[indexPath.item]
        detailViewController.delegate = self
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func collectionView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension FilmsViewController {
    fileprivate func collectionViewPreparation () {
        filmsCollectionView.register(UINib(nibName: "FilmTableViewCell",
                                           bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
    }

    func getFilms() {
        films = FilmsGenerator.generateFilms()
        self.filmsCollectionView.reloadData()
    }
}

extension FilmsViewController: LikeCountChanged {
    func likeButtonPressed(_ film: Film) {
        guard indexOfChoosenCell >= 0 else {
            return
        }
        let indexPath = IndexPath(item: indexOfChoosenCell, section: 0)
        filmsCollectionView.reloadItems(at: [indexPath])
    }
}
