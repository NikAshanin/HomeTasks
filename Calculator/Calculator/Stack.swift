import Foundation

class Stack {
    var arrayNumber: [String] = []
    var currentIndex = 0

    func insert <T>(_ element: T) {
        arrayNumber.append(String(describing: element))
        currentIndex += 1
    }
    func remove(from index: Int ) {
        let downRangeForDelete = index + 1
        let upRangeForDelete = arrayNumber.count - 1
        if downRangeForDelete < arrayNumber.count {
            arrayNumber.removeSubrange(downRangeForDelete...upRangeForDelete)
        }
    }
    func currentElement() -> String {
        return arrayNumber[currentIndex]
    }
    func returnDigitFromArray() -> Double {
        let elementForCheck = currentElement()
        return elementForCheck.isNumber() ? (Double(elementForCheck) ?? 0): 0
    }
    func returnPreviousElement() -> Double {
        let previousElement = arrayNumber[(currentIndex ) - 1]
        return previousElement.isNumber() ? (Double(previousElement) ?? 0): 0
    }
}
