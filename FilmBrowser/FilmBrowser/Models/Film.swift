import Foundation

final class Film {
    var title: String
    var image: String
    var descrip: String
    var likesCount: Int

    init(title: String,
         image: String,
         likesCount: Int,
         descrip: String) {
        self.title = title
        self.image = image
        self.likesCount = likesCount
        self.descrip = descrip
    }
}
