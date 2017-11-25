import Foundation

final class NetworkClient {

    // MARK: - Properties

    private let networkQueue = DispatchQueue(label: "NetworkClient.queue")
    private let session: URLSession

    // MARK: - Life cycle

    init() {
        self.session = URLSession(configuration: .default)
    }

    // MARK: - Public

    fileprivate func execute(request: URLRequest, completion: @escaping FetchCompletion) {
        networkQueue.async {
            let task = self.session.dataTask(with: request, completionHandler: { (data, _, error) in
                if let _error = error {
                    completion(.failure(_error))
                } else {
                    completion(.success(data))
                }
            })
            task.resume()
        }
    }
}

extension NetworkClient: NetworkManagement {
    func fetch(from url: URL, completion: @escaping FetchCompletion) {
            let request = URLRequest(url: url)
            execute(request: request, completion: completion)
        }
    }
