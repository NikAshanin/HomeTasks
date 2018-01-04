import UIKit

final class Film: Decodable {
    let title: String
    let image: String
    let description: String
    var likes: Int
}
