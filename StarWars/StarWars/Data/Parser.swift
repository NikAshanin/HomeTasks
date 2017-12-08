import Foundation

struct Parser {

    // MARK: - Properties

    fileprivate var dataTypeError: Error {
        return NSError(domain: "Invalid data type", code: 0) as Error
    }
}

extension Parser: ParserProtocol {

    func parseArray<T: JSONInitializable>(_ data: Data) throws -> T {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let model = T(json: json) else {
            throw dataTypeError
        }

        return model
    }
}
