import Foundation
import UIKit

class Film {
    let title: String
    let poster: UIImage
    var likes: Int
    let descr: String
    
    init(poster: UIImage, title: String, descr: String, likes: Int) {
        self.title = title
        self.poster = poster
        self.likes = likes
        self.descr = descr
    }
}
