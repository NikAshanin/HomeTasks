import Foundation

final class DataManager {

    // MARK: - Properties

    private let networkClient: NetworkManagement
    private let parser: ParserProtocol
    private var searchModel: SearchResultModel?
    var films = [FilmsModel]()

    init() {
        networkClient = NetworkClient()
        parser = Parser()
    }

    func loadFilmData(with character: String, completion: @escaping ([FilmsModel]) -> Void) {

        guard let formattedName = character.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
            let url = URL(string: "https://swapi.co/api/people/?search=\(formattedName)") else {
                return
        }

        getData(from: url) { [weak self] (models: SearchResultModel) in

            self?.searchModel = models
            self?.loadFilmsDescription(with: character, completion: {
                guard let films = self?.films else {
                    return
                }
                completion(films)
            })
        }
    }

    private func loadFilmsDescription(with character: String, completion: @escaping () -> Void) {
        films.removeAll()

        let filmDownloadingGroup = DispatchGroup()

        guard let films = searchModel?.nameAndFilmsList[character] else {
            return
        }

        for film in films {

            guard let filmURL = URL(string: film) else {
                continue
            }

            filmDownloadingGroup.enter()

            getData(from: filmURL, completion: { [weak self] (models: FilmsModel) in

                self?.films.append(models)

                filmDownloadingGroup.leave()
            })
        }

        filmDownloadingGroup.notify(queue: .main) {
            completion()
        }
    }

    private func getData<Data: JSONInitializable>(from url: URL, completion: @escaping (Data) -> Void) {

        networkClient.fetch(from: url) { [weak self] response in

            do {
                if let models: Data = try self?.parser.parseArray(response) {
                    completion(models)
                }
            } catch {
                assertionFailure("Unable to parse")
            }
        }
    }
}
