import Foundation

final class Film {
    let image: String
    let title: String
    let description: String
    var likes: Int

    init(image: String, title: String, description: String, likes: Int) {
        self.image = image
        self.title = title
        self.description = description
        self.likes = likes
    }
}
