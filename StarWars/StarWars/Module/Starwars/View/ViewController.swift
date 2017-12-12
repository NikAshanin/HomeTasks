import UIKit
import RxSwift
import RxOptional

class ViewController: UIViewController {
  @IBOutlet weak private var choosenInfo: UILabel!
  @IBOutlet weak private var name: UITextField!
  @IBOutlet weak private var tableView: UITableView!
  var presenter: StarwarsPresentation!
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = StarwarsPresenter(query:
      name.rx.controlEvent([.editingDidEnd]).asObservable().withLatestFrom(name.rx.text
        .distinctUntilChanged()
        .filterNil())
    )
    configureDataSource()
  }
}

// MARK: configure datasource
private extension ViewController {
  func configureDataSource() {
    bindDataSource()
    bindModelSelected()
  }

  func bindDataSource() {
    presenter.films.asDriver(onErrorJustReturn: [])
      .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, film, cell) in
        cell.textLabel?.text = film.name
      }.disposed(by: disposeBag)
  }

  func bindModelSelected() {
    tableView.rx.modelSelected(Film.self)
      .map { "Year = " + $0.year }
      .bind(to: choosenInfo.rx.text)
      .disposed(by: disposeBag)
  }
}
