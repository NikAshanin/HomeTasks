import Foundation
import UIKit

class Film: Decodable {
    let title: String
    let poster: String
    var likes: Int
    let description: String
}
