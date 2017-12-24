import Foundation

final class ModifyDate {
    static let dateformatter = DateFormatter()

    static func getYear(date: Date) -> Int? {
        ModifyDate.dateformatter.dateFormat = "yyyy-MM-dd"
        let modifyDate = ModifyDate.dateformatter.string(from: date)
        let calendar = Calendar.current
        let modifyDateString = ModifyDate.performStringToDate(date: modifyDate)
        guard let finalYear = modifyDateString else {
            return nil
        }
        return calendar.component(.year, from: finalYear)
    }
    static func performStringToDate(date: String) -> Date? {
        ModifyDate.dateformatter.dateFormat = "yyyy-MM-dd"
        let modifyDate = ModifyDate.dateformatter.date(from: date)
        return modifyDate
    }
}
