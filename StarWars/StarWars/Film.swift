import Foundation

final class Film {
    var name: String?
    var date: String?
    var year: Int? {
        guard let dateString = date else {
            return nil
        }
        return Film.getYearFromDateString(dateString)
    }
    let url: URL

    init(url: URL) {
        self.url = url
    }

    private class func getYearFromDateString(_ dateString: String) -> Int? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-mm-dd"
            return formatter
        }()
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return Calendar.current.component(.year, from: date)
    }
}
