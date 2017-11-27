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
        performSegue(withIdentifier: "detailInfoControll", sender: indexPath)
    }

    func collectionView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailInfoControll" {
            guard let destination = segue.destination as? DetailViewController,
                let indexPaths = sender as? IndexPath else {
                    return
            }
            indexOfChoosenCell = indexPaths.item
            destination.film = films[indexOfChoosenCell]
            destination.delegate = self
        }
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
