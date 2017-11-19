//
//  Film.swift
//  StarWars
//
//  Created by Artem Orlov on 19/11/2017.
//

import Foundation

struct Film {
    let title: String
    let releaseDate: Date

    init(title: String, releaseDate: Date) {
        self.title = title
        self.releaseDate = releaseDate
    }
}
