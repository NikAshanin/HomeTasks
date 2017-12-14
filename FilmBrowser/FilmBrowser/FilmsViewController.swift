import UIKit

final class FilmListViewController: UIViewController {

    @IBOutlet private weak var filmListTableView: UITableView!
    var cellViewModel: [FilmCellViewModel] = []
    var filmModel: [FilmModel] = []
    let filmInfo = InfoService()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()

        for i in filmInfo.plot {
            let element = FilmModel(i.0, i.1, i.0, 0)
            let cellElement = FilmCellViewModel(element)
            filmModel.append(element)
            cellViewModel.append(cellElement)
        }

        filmListTableView.estimatedRowHeight = 151
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filmListTableView.reloadData()
    }

    private func registerCell() {
        let nibName = UINib(nibName: "FilmTableViewCell", bundle: nil)
        filmListTableView.register(nibName, forCellReuseIdentifier: "filmCell")
    }
}

extension FilmListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as? FilmTableCell
        guard let filmCell = cell else {
            return UITableViewCell()
        }
        filmCell.configureCell(cellViewModel[indexPath.row])
        return filmCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = storyboard?.instantiateViewController(withIdentifier: "DetailViewController")
        guard let detailView = s as? DetailViewController else {
            return
        }
        detailView.delegate = self
        detailView.filmDetail = filmModel[indexPath.row]
        selectedIndex = indexPath.row
        navigationController?.pushViewController(detailView, animated: true)
    }
}

// MARK: - Extension

extension FilmListViewController: LikeCountChangeProtocol {
    func likeCountChange(_ value: Int) {
        cellViewModel[selectedIndex].likesCount = value
        filmModel[selectedIndex].like = value
    }
}
