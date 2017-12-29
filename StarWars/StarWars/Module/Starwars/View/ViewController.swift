//
//  ViewController.swift
//  Starwars
//
//  Created by Антон Назаров on 16.11.2017.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak private var output: UITextView!

  var presenter: StarwarsInput! = StarwarsPresenter()

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.output = self
  }
}

extension ViewController: StarwarsDelegate {
  func set(result: String) {
    output.text = result
  }
}
