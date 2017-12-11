import Foundation

final class ModifyDate {
  static let dateformatter = DateFormatter()

  func cutYear(date: String) -> Int {
    ModifyDate.dateformatter.dateFormat = "yyyy-MM-dd"
    let modifyDate = ModifyDate.dateformatter.date(from: date)
    let calendar = Calendar.current
    guard let modifyDateCheck = modifyDate else {
      return 0
    }
    return calendar.component(.year, from: modifyDateCheck)
  }
}
