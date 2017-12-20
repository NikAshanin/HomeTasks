import Foundation
import UIKit
final class Film {
    let image: UIImage
    let name: String
    let description: String
    var likesCount: Int
    var liked: Bool

    init(name: String, image: UIImage, description: String, likesCount: Int, liked: Bool) {
        self.name = name
        self.image = image
        self.description = description
        self.likesCount = likesCount
        self.liked = liked
    }

    private func addLike() {
            likesCount+=1
            liked = true
    }

    private func removeLike() {
            likesCount-=1
            liked = false
    }
    
    func changeLikeState() {
        liked ? removeLike() : addLike()
    }
}
