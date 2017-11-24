import Foundation

struct FilmSources {

    static func fetchDescriptions() -> [Film] {
        for index in 1...8 {
            if let path = Bundle.main.path(forResource: "E_\(index)", ofType: "txt") {
                let description = (try? String(contentsOfFile: path, encoding: .utf8)) ?? "error"
                FilmSources.descriptions.append(description)
            }
        }
       let films = [
        Film(poster: #imageLiteral(resourceName: "E_1.jpg"), title: E1Title, descr: descriptions[0], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_2.jpg"), title: E2Title, descr: descriptions[1], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_3.jpg"), title: E3Title, descr: descriptions[2], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_4.jpg"), title: E4Title, descr: descriptions[3], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_5.jpg"), title: E5Title, descr: descriptions[4], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_6.jpg"), title: E6Title, descr: descriptions[5], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_7.jpg"), title: E7Title, descr: descriptions[6], likes: 0),
        Film(poster: #imageLiteral(resourceName: "E_8.jpg"), title: E8Title, descr: descriptions[7], likes: 0)
        ]
        return films
    }

    static let E1Title = "Star Wars: Episode I – The Phantom Menace"
    static let E2Title = "Star Wars: Episode II – Attack of the Clones"
    static let E3Title = "Star Wars: Episode III – Revenge of the Sith"
    static let E4Title = "Star Wars: Episode IV - A New Hope"
    static let E5Title = "Star Wars: Episode V - The Empire Strikes Back"
    static let E6Title = "Star Wars: Episode VI - Return of the Jedi"
    static let E7Title = "Star Wars: Episode VII - The Force Awakens"
    static let E8Title = "Star Wars: Episode VIII - The Last Jedi"

    static var descriptions = [String]()
}
