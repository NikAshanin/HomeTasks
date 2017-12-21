import Foundation

final class Film: Decodable {
    public let title: String
    public let description: String
    public let imageName: String
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

    public func addLike() {
        likes += 1
    }

    public func getLikes() -> Int {
        return likes
    }
}
