import Foundation

class ModifyDate {
  
  let dateformatter = DateFormatter()
  
  func cutYear(date: String) -> Int {
    dateformatter.dateFormat = "yyyy-MM-dd"
    let modifyDate = dateformatter.date(from: date)
    let calendar = Calendar.current
    let year = calendar.component(.year, from: modifyDate!)
    return year
  }
}
