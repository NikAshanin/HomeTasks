import Foundation

final class NetworkClient {

    // MARK: - Properties

    private let session: URLSession

    init() {
        session = URLSession(configuration: .default)
    }

    fileprivate func execute(request: URLRequest, completion: @escaping FetchCompletion) {
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

extension NetworkClient: NetworkManagement {
    func fetch(from url: URL, completion: @escaping FetchCompletion) {
            let request = URLRequest(url: url)
            execute(request: request, completion: completion)
        }
    }
