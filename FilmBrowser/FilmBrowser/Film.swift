import Foundation

final class Film {
    var name: String
    var imageName: String
    var description: String
    var likeCount: Int

    init(name: String, imageName: String, description: String, likeCount: Int) {
        self.name = name
        self.imageName = imageName
        self.description = description
        self.likeCount = likeCount
    }
}
