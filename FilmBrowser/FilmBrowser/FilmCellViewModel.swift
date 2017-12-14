final class FilmCellViewModel {

    var filmLogo: String?
    var filmName: String?
    var likesCount: Int?

    init(_ film: FilmModel) {
        guard let logo = film.logo,
            let name = film.name,
            let likes = film.like
            else { return }

        filmLogo = logo
        filmName = name
        likesCount = likes
    }
}
