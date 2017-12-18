import Foundation
class FilmsGenerator {
    private static var films = [Film]()

    static func generateFilms() -> [Film] {
        films.append(Film(name: "Minions",
                          image: #imageLiteral(resourceName: "minions"), description: "LAPOTA!", likesCount: 2, liked: false))
        films.append(Film(name: "How to get away with a murder",
                          image: #imageLiteral(resourceName: "htgawm"), description: "How to Get Away with Murder is an American drama"
            + "television series that premiered on ABC on September 25, 2014.", likesCount: 2, liked: false))
        films.append(Film(name: "Two and a half men",
                          image: #imageLiteral(resourceName: "two_men"), description: "Two and a Half Men is an American television sitcom that originally"
            + "aired on CBS for twelve seasons from September 22, 2003 to February 19, 2015", likesCount: 2, liked: false))
        films.append(Film(name: "Glee",
                          image: #imageLiteral(resourceName: "glee"), description: "Glee is an American musical comedy-drama television"
            + "series that aired on the Fox network in the United States from" +
            "May 19, 2009, to March 20, 2015", likesCount: 2, liked: false))
        films.append(Film(name: "The big bang theory",
                          image: #imageLiteral(resourceName: "tbbt"), description: "The Big Bang Theory is an American television sitcom created by"
            + "Chuck Lorre and Bill Prady, both of whom serve as executive" +
            "producers on the series,", likesCount: 2, liked: false))
        films.append(Film(name: "Shameless",
                          image: #imageLiteral(resourceName: "shameless"), description: "Shameless is an American comedy-drama television series developed by"
            + "John Wells that debuted on Showtime on January 9, 2011", likesCount: 2, liked: false))
        films.append(Film(name: "How i met your mother",
                          image: #imageLiteral(resourceName: "himym"), description: "How I Met Your Mother (often abbreviated to HIMYM) is "
            + "an American sitcom that originally aired on CBS from"
            + "September 19, 2005 to March 31, 2014", likesCount: 2, liked: false))
        films.append(Film(name: "Vice principals",
                          image: #imageLiteral(resourceName: "vice"), description: "Vice Principals is an American comedy television series starring"
            + "Danny McBride, Walton Goggins, Kimberly Hebert Gregory, Dale Dickey, Georgia King", likesCount: 2, liked: false))
        films.append(Film(name: "Young Sheldon",
                          image: #imageLiteral(resourceName: "young_sheldon"), description: "Young Sheldon (stylized as young Sheldon) is an American"
            + "television sitcom on CBS created by Chuck Lorre and Steven Molaro.", likesCount: 2, liked: false))
        films.append(Film(name: "Grey's anatomy",
                          image: #imageLiteral(resourceName: "greys"), description: "Grey's Anatomy is an American medical drama television"
            + "series that premiered on American Broadcasting Company" +
                            "(ABC) as a mid-season replacement", likesCount: 2, liked: false))
        return films
    }
}
