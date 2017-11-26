import Foundation

final class FilmObject: Decodable {
    var filmName: String
    var imageName: String
    var description: String
    var likeCount: Int
    init(filmName: String, imageName: String, description: String, likeCount: Int) {
        self.filmName = filmName
        self.imageName = imageName
        self.description = description
        self.likeCount = likeCount
    }
}
