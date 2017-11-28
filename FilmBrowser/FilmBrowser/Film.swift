import Foundation
import UIKit

final class Film: Decodable, Comparable {

    static func < (lhs: Film, rhs: Film) -> Bool {
        return lhs.title < rhs.title &&
                lhs.likes < rhs.likes
    }

    static func == (lhs: Film, rhs: Film) -> Bool {
        return lhs.title == rhs.title &&
            lhs.poster == rhs.poster &&
            lhs.likes == rhs.likes &&
            lhs.description == rhs.description
    }

    let title: String
    let poster: String
    var likes: Int
    let description: String
}
