

import Foundation

class Stack{
  var arrayNumber: [String] = [] {
    willSet{
      currentIndex = arrayNumber.count
    }
  }
  var currentIndex: Int?
  func insert <T>(_ element: T) {
    arrayNumber.append(String(describing: element))
  }
  func remove(from index: Int ){
    let downRangeForDelete = index + 1
    let upRangeForDelete = arrayNumber.count - 1
    if downRangeForDelete < arrayNumber.count{
        arrayNumber.removeSubrange(downRangeForDelete...upRangeForDelete)
    }
  }
}





