import RxCocoa

protocol StarwarsPresentation {
  var films: Driver<[Film]> { get }
}
