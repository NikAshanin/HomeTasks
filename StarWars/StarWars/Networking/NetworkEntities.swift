import Foundation

typealias FetchCompletion = (Data) -> Void

protocol NetworkManagement {
    func fetch(from url: URL, completion: @escaping FetchCompletion)
}
