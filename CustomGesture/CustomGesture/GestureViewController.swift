//
//  ViewController.swift
//  oWithTabs
//
//  Created by Sitora on 12.11.17.
//  Copyright © 2017 Ira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var feedbackLabel = UILabel(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "circle.jpg")
        imageView.contentMode = .scaleAspectFit
        //add gesture recognizer
        let oRecognizer = ORecognizer (midPoint: self.view.center, target: self, action: #selector(oRecognized))
        view.addGestureRecognizer(oRecognizer)
        //add feedbackLabel
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feedbackLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|", options: [], metrics: nil, views: ["view": feedbackLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: [], metrics: nil, views: ["view": feedbackLabel]))
        feedbackLabel.textAlignment = .center
        feedbackLabel.numberOfLines = 0
        feedbackLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        feedbackLabel.text = "Perform a gesture circle here."
    }
    @objc func oRecognized() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "tabBar")
        self.present(homeViewController, animated: true, completion: nil)
    }
}
