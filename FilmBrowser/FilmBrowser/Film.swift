import UIKit

final class Film {
    let name: String
    let director: String
    let plot: String?
    let posterImage: UIImage?
    var likes = 0

    init(name: String, director: String, resourseId: String) {
        self.plot = resourseId.getTextFromResourses()
        self.posterImage = UIImage(named: resourseId + ".jpg")
        self.name = name
        self.director = director
    }
}

private extension String {
    func getTextFromResourses() -> String? {
        do {
            let text = try String(contentsOfFile: Bundle.main.path(forResource: self, ofType: "txt") ?? "")
            return text
        } catch {
            return nil
        }
    }
}
