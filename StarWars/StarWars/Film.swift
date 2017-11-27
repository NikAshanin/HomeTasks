import Foundation

final class Film {

    let info: [String: Any]
    let title: String
    let date: Date

    init(info: [String: Any], title: String, date: Date) {
        self.info = info
        self.title = title
        self.date = date
    }
}
