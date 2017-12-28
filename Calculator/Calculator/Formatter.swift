import Foundation

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.notANumberSymbol = "Ошибка"
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
} ()
