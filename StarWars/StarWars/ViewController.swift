import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {
    var swData = SwapiData()

     @IBOutlet private weak var tableView: UITableView!
     @IBOutlet private weak var textField: UITextField!

    private let group = DispatchGroup()
    private var isFilms = false

    private let swRequester = SwapiRequester()

    override func viewDidLoad() {
        super.viewDidLoad()

        swRequester.dataReceieverDelegate = self
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.sync {
            swRequester.loadData()
        }
        textField.delegate = self
    }

    @IBAction func search(_ textField: UITextField) {
        guard let text = textField.text?.lowercased(), !text.isEmpty else {
            return
        }

        var row = -1
        for index in 0...swData.characterCount() {
            if swData.characterCount() == 0 {
                return
            }
            let character = swData.getCharacter(index: index)
            if character.name.lowercased().contains(text) {
                row = index
                break
            }
        }

        tableView.selectRow(at: IndexPath(row: row, section: 0),
                            animated: true, scrollPosition: .middle)
    }

    private func displayFilms(index: Int) {
        if isFilms {
            isFilms = !isFilms
            tableView.reloadData()
        } else {
            let character = swData.getCharacter(index: index)
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                self.swRequester.getFilms(characterURL: character.url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let w = 1 - scrollView.contentOffset.y / scrollView.contentSize.height
        view.backgroundColor = UIColor(white: w, alpha: 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilms ? swData.filmCount() : swData.characterCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? WebsiteTableViewCell else {
            return UITableViewCell()
        }

        if isFilms {
            let film = swData.getFilm(index: indexPath.row )
            cell.setText(film.name + " - " + film.date)
        } else {
            let character = swData.getCharacter(index: indexPath.row )
            cell.setText(character.name)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilms {
            isFilms = !isFilms
            self.tableView.reloadData()
        } else {
            displayFilms(index: indexPath.row)
        }

        return
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "First" : "Not first"
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        guard let index = tableView.indexPathForSelectedRow?.row else {
            return false
        }
        displayFilms(index: index)

        return true
    }
}
extension ViewController: SwapiDataRecieverDelegate {
    func dataIsReady(isFilms: Bool) {
        DispatchQueue.main.async {
            self.isFilms = isFilms
            self.swData = self.swRequester.swData
            self.tableView.reloadData()
        }
    }
}
