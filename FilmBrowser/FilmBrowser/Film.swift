import Foundation

final class Film {
    var name: String
    var imageName: String
    var descriptionFilm: String
    var likeCount: Int

    init(name: String, imageName: String, descriptionFilm: String, likeCount: Int) {
        self.name = name
        self.imageName = imageName
        self.descriptionFilm = descriptionFilm
        self.likeCount = likeCount
    }
}
