final class FilmModel {

    var name: String?
    var description: String?
    var logo: String?
    var like: Int?

    init(_ name: String, _ description: String, _ logo: String, _ like: Int) {
        self.name = name
        self.description = description
        self.logo = logo
        self.like = like
    }
}
