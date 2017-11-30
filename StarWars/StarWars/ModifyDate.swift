import Foundation

final class ModifyDate {
  let dateformatter = DateFormatter()

  func cutYear(date: String) -> Int {
    dateformatter.dateFormat = "yyyy-MM-dd"
    let modifyDate = dateformatter.date(from: date)
    let calendar = Calendar.current
    guard let modifyDateCheck = modifyDate else {
      return 0
    }
    let year = calendar.component(.year, from: modifyDateCheck)
    return year
  }
}
