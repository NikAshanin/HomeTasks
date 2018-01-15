import Foundation

final class Film {
    var date: Date
    var title: String

    init(_ date: Date, _ title: String) {
        self.date = date
        self.title = title
    }
}
