import Foundation

final class DataManager {

    // MARK: - Properties

    private let dataManagementQueue: OperationQueue
    private let networkClient: NetworkManagement
    private let parser: Parsable
    private let filmDownloadingGroup = DispatchGroup()
    private var searchModel: SearchResultModel?
    private var films = [FilmsModel]()

    init() {
        self.dataManagementQueue = OperationQueue()
        self.networkClient = NetworkClient()
        self.parser = Parser()
    }

    // MARK: - Public

    func loadData(with character: String, completion: @escaping ([FilmsModel]) -> Void) {

        getCharacterInfo(name: character) { [weak self] response in

            assert(!Thread.isMainThread)

            self?.handle(response, onSuccess: { models in
                self?.searchModel = models
                self?.loadFilmsDescriptionWith(character, completion: {
                    guard let films = self?.films else {
                        return
                    }
                    completion(films)
                })
            })
        }
    }

    private func loadFilmsDescriptionWith(_ character: String, completion: @escaping () -> Void) {
        films.removeAll()

        guard let films = searchModel?.nameAndFilmsList[character] else {
                return
        }

        for film in films {

            filmDownloadingGroup.enter()

            guard let filmURL = URL(string: film) else {
                return
            }

            getFilmsTitles(url: filmURL) { [weak self] response in

                assert(!Thread.isMainThread)

                self?.handle(response, onSuccess: { [weak self] models in
                    DispatchQueue.main.async {
                        self?.films.append(models)
                    }

                    self?.filmDownloadingGroup.leave()
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

    func getCharacterInfo(name: String, completion: @escaping (Response<SearchResultModel>) -> Void) {
        guard let formattedName = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return
        }

        let URLString = "https://swapi.co/api/people/?search=\(formattedName)"

        guard let url = URL(string: URLString) else {
            return
        }

        getData(from: url, completion: completion)
    }

    func getFilmsTitles(url: URL, completion: @escaping (Response<FilmsModel>) -> Void) {
        getData(from: url, completion: completion)
    }

    // MARK: - Private

    private func getData<Data: JSONInitializable>(from url: URL, completion: @escaping (Response<Data>) -> Void) {

        dataManagementQueue.addOperation {
            [weak self] in

            self?.networkClient.fetch(from: url) { [weak self] response in

                switch response {
                case .success(let data):
                    do {
                        if let data = data, let models: Data = try self?.parser.parseArray(data) {
                            completion(.success(models))
                        }
                    } catch {
                        completion(.failure(error))
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
