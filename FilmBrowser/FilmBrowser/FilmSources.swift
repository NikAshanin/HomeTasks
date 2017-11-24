import Foundation

struct FilmSources {
    
    static func getDescriptions() {
        for index in 1...8 {
            let path = Bundle.main.path(forResource: "E_\(index)", ofType: "txt")
            let description = (try? String(contentsOfFile: path!, encoding: .utf8)) ?? "error"
            FilmSources.descriptions.append(description)
        }
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

