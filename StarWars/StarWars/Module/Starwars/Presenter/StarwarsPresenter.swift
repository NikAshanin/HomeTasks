//
//  StarwarsViewModel.swift
//  Starwars
//
//  Created by Антон Назаров on 26.10.2017.
//

import Foundation

class StarwarsPresenter: StarwarsInput {
  private let networkService = NetwowkService()
  var output: StarwarsDelegate? {
    didSet {
      output?.set(result: getFilmNames().joined(separator: ","))
    }
  }

  private func getFilmNames() -> [String] {
    guard let filmUrlsString =
      networkService.getJsonFrom(url: Endpoint.getPeopleUrl(id: PeopleId.Luke))["films"] as? [String] else {
      return []
    }
    var filmNames = [String]()
    let filmsGroup = DispatchGroup()
    for filmUrlString in filmUrlsString {
      guard let filmUrl = URL(string: filmUrlString) else {
        return []
      }

      DispatchQueue.global(qos: .userInitiated).async(group: filmsGroup) {
        if let filmName = self.networkService.getJsonFrom(url: filmUrl)["title"] as? String {
          DispatchQueue.global(qos: .userInitiated).sync {
            filmNames.append(filmName)
          }
        }
      }
    }

    filmsGroup.wait()
    return filmNames
  }
}
