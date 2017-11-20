//
//  UIService.swift
//  CalculatorProject
//
//  Created by Alexander on 09.11.17.
//  Copyright © 2017 Kas. All rights reserved.
//

import UIKit.UIAlert

class AlertService {
    static func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(OKAction)
        if var viewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = viewController.presentedViewController {
                viewController = presentedViewController
            }
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
