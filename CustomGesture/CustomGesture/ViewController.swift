//
//  ViewController.swift
//  circle
//
//  Created by Sergey Gusev on 13.11.2017.
//  Copyright © 2017 Sergey Gusev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue:CGFloat = 0.0 {
        didSet {
            if (currentValue > 100) {
                currentValue = 100
            }
            if (currentValue < 0) {
                currentValue = 0
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(CircleGestureRecognizer(midPoint: self.view.center, target: self, action: #selector(ViewController.rotateGesture(recognizer:))))
    }
    @objc func rotateGesture(recognizer:CircleGestureRecognizer)
    {
        if let rotation = recognizer.rotation {
            currentValue += rotation.degrees / 360 * 100
        }
        if currentValue == 100 {
        let alert = UIAlertController(title: "Recognized", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in
            if let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabBarColl") as? UITabBarController {
                self.present(tabBar,animated: true, completion: nil)
            }
        }))
        present(alert,animated: true, completion: nil)
        }
    }

}

