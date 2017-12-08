import Foundation

final class NetworkClient {

    // MARK: - Properties

    private let networkQueue = DispatchQueue(label: "NetworkClient.queue")
    private let session: URLSession

    init() {
        self.session = URLSession(configuration: .default)
    }

    // MARK: - Public

    fileprivate func execute(request: URLRequest, completion: @escaping FetchCompletion) {
        networkQueue.async {
            let task = self.session.dataTask(with: request, completionHandler: { (data, _, _) in
                if let data = data {
                    completion(data)
                } else {
                    assertionFailure()
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
