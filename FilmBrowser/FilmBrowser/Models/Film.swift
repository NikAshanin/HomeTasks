import Foundation

final class Film {
    var title: String
    var image: String
    var description: String
    var likesCount: Int

    init(title: String,
         image: String,
         likesCount: Int,
         description: String) {
        self.title = title
        self.image = image
        self.likesCount = likesCount
        self.description = description
    }
}
