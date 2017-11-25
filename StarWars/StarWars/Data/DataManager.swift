import Foundation

final class DataManager {

    // MARK: - Properties

    private let dataManagementQueue: OperationQueue
    private let networkClient: NetworkManagement
    private let parser: Parsable

    // MARK: - Life cycle

    init() {
        self.dataManagementQueue = OperationQueue()
        self.networkClient = NetworkClient()
        self.parser = Parser()
    }

    // MARK: - Public

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
            [unowned self] in

            self.networkClient.fetch(from: url) { [unowned self] response in

                switch response {
                case .success(let data):
                    guard let _data = data else {
                        assertionFailure()
                        return
                    }

                    do {
                        let models: Data = try self.parser.parseArray(_data)

                        completion(.success(models))
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
