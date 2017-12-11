//
//  ViewController.swift
//  Calculator
//
//  Created by Антон Назаров on 24.10.2017.
//

import UIKit

class ViewController: UIViewController {
  var presenter: CalculatorInput = CalculatorPresenter()

  @IBOutlet weak private var undo: UIButton!

  @IBAction func undo(_ sender: UIButton) {
    presenter.undo()
  }

  @IBAction func sybmolPressed(_ sender: UIButton) {
    guard let symbol = sender.titleLabel?.text else {
      return
    }
    self.presenter.input = symbol
  }

  @IBOutlet weak private var result: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.output = self
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    if UIDevice.current.orientation.isLandscape {
      undo.isHidden = false
    } else {
      undo.isHidden = true
    }
  }
}

// MARK: calculator delegate
extension ViewController: CaclulatorDelegate {
  func set(result: String) {
    self.result.text = result
  }
}
