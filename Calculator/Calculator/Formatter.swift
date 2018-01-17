import Foundation

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 15
    formatter.notANumberSymbol = "Ошибка"
    formatter.groupingSeparator = " "
    formatter.locale = Locale.current
    return formatter
} ()
