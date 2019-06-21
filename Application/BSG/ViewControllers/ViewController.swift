//
//  ViewController.swift
//  BSG
//
//  Created by Saransh Mittal on 17/06/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var yesterdayPractisedLabel: UILabel!
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
    
    @objc func changeLastSeen(){
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.minutes) {
            lastSeenMinutes = Int(stringOne)!
        }
        if let stringTwo = defaults.string(forKey: defaultsKeys.hours) {
            lastSeenHours = Int(stringTwo)!
        }
        if lastSeenHours < 12{
            if lastSeenMinutes<10{
                lastSeenLabel.text = "last seen at " + String(lastSeenHours) + ":0" + String(lastSeenMinutes) + " AM"
            } else {
                lastSeenLabel.text = "last seen at " + String(lastSeenHours) + ":" + String(lastSeenMinutes) + " AM"
            }
        } else {
            if lastSeenMinutes<10{
                lastSeenLabel.text = "last seen at " + String(lastSeenHours%12) + ":0" + String(lastSeenMinutes) + " AM"
            } else {
                lastSeenLabel.text = "last seen at " + String(lastSeenHours%12) + ":" + String(lastSeenMinutes) + " AM"
            }
        }
    }
    
    var totalPractisedMinutesOfToday = 0
    var practisedDay = 0
    var practisedMonth = 0
    var practisedYear = 0
    
    func loadSession(){
        let currentDate = Date()
        let calendar = Calendar.current
        let defaults = UserDefaults.standard
        if let month = defaults.string(forKey: lastPractised.month) {
            var MONTH = Int(month)!
            if let year = defaults.string(forKey: lastPractised.year) {
                var YEAR = Int(year)!
                if let date = defaults.string(forKey: lastPractised.day) {
                    var DATE = Int(date)!
                    if DATE == calendar.component(.day, from: currentDate) && MONTH == calendar.component(.month, from: currentDate) && YEAR == calendar.component(.year, from: currentDate) {
                        if let practisedMin = defaults.string(forKey: lastPractised.minutes) {
                            totalPractisedMinutesOfToday = Int(practisedMin)!
                            print(totalPractisedMinutesOfToday)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changePractisedToday()
    }
    
    @objc func changePractisedToday(){
        loadSession()
        todayMinutesPractiseLabel.text = " " + String(totalPractisedMinutesOfToday) + " minutes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLastSeen()
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeLastSeen), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changePractisedToday), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

