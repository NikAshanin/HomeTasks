import UIKit

final class Film {
    let name: String
    let director: String
    let plot: String?
    let posterImage: UIImage?
    var likes = 0
    var likeString: String {
        return "♥ \(self.likes)"
    }

    init(name: String, director: String, resourseId: String) {
        self.plot = Bundle.getTextFromResourses(resourseName: resourseId)
        self.posterImage = UIImage(named: resourseId + ".jpg")
        self.name = name
        self.director = director
    }
}

private extension Bundle {
    static func getTextFromResourses(resourseName: String) -> String? {
        do {
            guard let path = self.main.path(forResource: resourseName, ofType: "txt") else {
                return ""
            }
            let text = try String(contentsOfFile: path)
            return text
        } catch {
            return nil
        }
    }
}
