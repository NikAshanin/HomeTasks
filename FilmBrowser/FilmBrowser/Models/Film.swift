import Foundation

final class Film: Decodable {
    let title: String
    let description: String
    let imageName: String
    private var likes: Int

    init(title: String,
         description: String,
         imageName: String,
         likes: Int) {

        self.title = title
        self.description = description
        self.imageName = imageName
        self.likes = likes
    }

    func addLike() {
        likes += 1
    }

    var getLikes: Int {
        return likes
    }
}
