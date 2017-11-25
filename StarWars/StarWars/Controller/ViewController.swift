import UIKit

final class ViewController: UIViewController {

    // MARK: - Properties

    private let dataManager = DataManager()
    private var searchModel: SearchResultModel?
    private var films = [FilmsModel]()
    private let dateFormatter = DataFormatterConfigurator()
    private let calendar = Calendar.current
    private let filmDownloadingGroup = DispatchGroup()

    // MARK: - Outlets

    @IBOutlet weak private var filmsTableView: UITableView!
    @IBOutlet weak private var filmYear: UILabel!
    @IBOutlet weak private var searchTextField: UITextField!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        searchTextField.delegate = self
    }

    private func registerCells() {
        let nib = UINib(nibName: "FilmTitleCell", bundle: Bundle.main)
        filmsTableView.register(nib, forCellReuseIdentifier: FilmTitleCell.reuseId)
    }

    private func createSearchURLForSearchTerm(_ searchTerm: String) -> URL? {

        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }

        let URLString = "https://swapi.co/api/people/?search=\(escapedTerm)"

        guard let url = URL(string: URLString) else {
            return nil
        }

        return url
    }

    private func loadData(with character: String) {

        dataManager.getCharacterInfo(name: character) { [weak self] response in

            assert(!Thread.isMainThread)

            guard let sSelf = self else {
                return
            }

            sSelf.handle(response, onSuccess: { [weak self] models in
                guard let sSelf = self else {
                    return
                }

                DispatchQueue.main.async {
                    sSelf.searchModel = models
                    sSelf.loadFilmsDescriptionWith(character, completion: sSelf.updateUI)
                }
            })
        }
    }

    private func loadFilmsDescriptionWith(_ character: String, completion: @escaping () -> Void) {
        guard searchModel?.nameAndFilmsList[character] != nil,
            let films = searchModel?.nameAndFilmsList[character] else {
                return
        }

        for film in films {

            filmDownloadingGroup.enter()

            guard let filmURL = URL(string: film) else {
                return
            }

            dataManager.getFilmsTitles(url: filmURL) { [weak self] response in

                assert(!Thread.isMainThread)

                guard let sSelf = self else {
                    return
                }

                sSelf.handle(response, onSuccess: { [weak self] models in
                    guard let sSelf = self else {
                        return
                    }

                    DispatchQueue.main.async {
                        sSelf.films.append(models)
                    }

                    sSelf.filmDownloadingGroup.leave()
                })
            }
        }

        filmDownloadingGroup.notify(queue: .main) {
            completion()
        }
    }

    private func handle<T>(_ response: Response<T>, onSuccess: (T) -> Void) {
        switch response {
        case .success(let models):
            onSuccess(models)
        case .failure(let error):
            assertionFailure("Error \(error)")
        }
    }

    private func updateUI() {
        filmsTableView.reloadData()
    }

    private func clearTableView() {
        searchModel = nil
        filmYear.text = nil
        films.removeAll()

        updateUI()
    }
}

// MARK: - Text Field Delegate

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text else {
            return false
        }

        clearTableView()

        loadData(with: text)

        return true
    }
}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = films[indexPath.row]
        guard let cell = filmsTableView.dequeueReusableCell(withIdentifier: FilmTitleCell.reuseId) as? FilmTitleCell else {
            return UITableViewCell()
        }

        cell.configure(film)

        return cell
    }
}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let date = dateFormatter.date(from: films[indexPath.row].releaseDate) else {
            return
        }
        let year = calendar.component(.year, from: date)

        filmYear.text = String(year)
    }
}
