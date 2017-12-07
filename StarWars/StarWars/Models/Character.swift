import Foundation

final class Character {
    let name: String
    let linksToFilmsWithCharacter: [String]

    init?(json: [String: Any]) {
        guard let characterName = json["name"] as? String,
            let filmsWithCharacter = json["films"] as? [String] else {
                return nil
        }
        self.name = characterName
        self.linksToFilmsWithCharacter = filmsWithCharacter
    }

    init(name: String, links: [String]) {
        self.name = name
        self.linksToFilmsWithCharacter = links
    }
}
