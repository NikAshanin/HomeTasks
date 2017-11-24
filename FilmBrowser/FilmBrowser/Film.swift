//
//  Film.swift
//  FilmBrowser
//
//  Created by Юрий Сорокин on 24/11/2017.
//  Copyright © 2017 epam. All rights reserved.
//

import Foundation
import UIKit

class Film {
    let title: String
    let poster: UIImage
    let likes: String
    let descr: String
    
    init(poster: UIImage, title: String, descr: String, likes: Int) {
        self.title = title
        self.poster = poster
        self.likes = String(likes)
        self.descr = descr
    }
}
