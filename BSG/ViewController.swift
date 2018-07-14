//
//  ViewController.swift
//  BSG
//
//  Created by Saransh Mittal on 17/06/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let hours = "0"
    static let minutes = "0"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var todayMinutesPractiseLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            let translation = gestureRecognizer.translation(in: self.view)
////            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
//            bottomHeightConstraint.constant = bottomHeightConstraint.constant - translation.y
//            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let date = Date()
        let calendar = Calendar.current
        var currentHour = calendar.component(.hour, from: date)
        var currentMinutes = calendar.component(.minute, from: date)
        let defaults = UserDefaults.standard
        defaults.set(String(currentHour), forKey: defaultsKeys.hours)
        defaults.set(String(currentMinutes), forKey: defaultsKeys.minutes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.minutes) {
            lastSeenMinutes = Int(stringOne)!
        }
        if let stringTwo = defaults.string(forKey: defaultsKeys.hours) {
            lastSeenHours = Int(stringTwo)!
        }
        todayMinutesPractiseLabel.text = " " + String(practisedMinutes) + " minutes"
        if lastSeenHours > 12{
            lastSeenLabel.text = "last seen at " + String(lastSeenHours%12) + ":" + String(lastSeenMinutes) + " PM"
        } else {
            lastSeenLabel.text = "last seen at " + String(lastSeenHours) + ":" + String(lastSeenMinutes) + " AM"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        self.bottomView.addGestureRecognizer(gestureRecognizer)
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

