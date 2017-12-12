import RxCocoa
import RxAlamofire
import RxSwift

let apiError = "Api not consistent"

class StarwarsPresenter: StarwarsPresentation {
  var films: Driver<[Film]>

  init(query: Observable<String>) {
    films = query
      .observeOn(OperationQueueScheduler(operationQueue: OperationQueue()))
      .flatMap { RxAlamofire.requestJSON(.get, searchUrl(for: $0)) }
      .flatMap { _, json -> Observable<[String]> in
        guard let dict = json as? [String: AnyObject],
          let results = dict["results"] as? [[String: AnyObject]],
          let films = results[0]["films"] as? [String] else {
            fatalError(apiError)
        }
        return Observable.just(films)
      }
      //TOASK is there the way to make it little bit more cool?
      .map { $0.map {
        RxAlamofire.requestJSON(.get, $0)
          .flatMap {_, json -> Observable<Film> in
            guard let dict = json as? [String: AnyObject],
              let name = dict["title"] as? String,
              let year = dict["release_date"]  as? String else {
                fatalError(apiError)
            }
            return Observable.just(Film(name: name, year: year))
          }
      }
      }
      .flatMap { Observable.merge($0).toArray() }
      .asDriver(onErrorJustReturn: [])
  }
}
