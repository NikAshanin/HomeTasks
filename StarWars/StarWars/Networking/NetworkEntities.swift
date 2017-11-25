import Foundation

typealias FetchCompletion = (Response<Data?>) -> Void

protocol NetworkManagement {
    func fetch(from url: URL, completion: @escaping FetchCompletion)
}
