import UIKit

final class FilmsViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var filmsCollectionView: UICollectionView!
    private var films = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        getFilms()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let filmCell = cell as? FilmTableViewCell {
            filmCell.setFilmInfo(films[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController"),
            let detailViewController = newViewController as? DetailViewController else {
                return
        }
        detailViewController.film = films[indexPath.item]
        detailViewController.delegate = self
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FilmsViewController {
    fileprivate func prepareCollectionView () {
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
        guard let indexOfFilm = films.index(where: { $0 === film }) else {
            return
        }
        let indexPath = IndexPath(item: indexOfFilm, section: 0)
        filmsCollectionView.reloadItems(at: [indexPath])
    }
}
