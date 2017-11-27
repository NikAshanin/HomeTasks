import Foundation
import UIKit
final class Film {
    let image: UIImage
    let name: String
    let description: String
    var likesCount: Int
    var liked: Bool

    required init(name: String, image: UIImage, description: String, likesCount: Int, liked: Bool) {
        self.name = name
        self.image = image
        self.description = description
        self.likesCount = likesCount
        self.liked = liked
    }

    public func addLike() {
        if !liked {
            likesCount+=1
            liked = true
        }
    }

    public func removeLike() {
        if liked {
            likesCount-=1
            liked = false
        }
    }
}
