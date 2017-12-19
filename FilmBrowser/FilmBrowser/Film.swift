import UIKit

final class Film {
    var title: String
    var image: String
    var likes: Int = 0

    init(title: String, image: String, likes: Int) {
        self.title = title
        self.image = image
        self.likes = likes
    }
}
