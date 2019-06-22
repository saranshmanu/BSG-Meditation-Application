//
//  HomeViewController.swift
//  BSG
//
//  Created by Saransh Mittal on 17/06/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var practiseDurationLabelYesterday: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var practiseDurationLabel: UILabel!
    
    func changePractiseTime() {
        practiseDurationLabel.text = " \(Data.totalPractiseMinutes) minutes"
    }

    @objc func changeLastSeen() {
        if Data.lastSeenMinutes < 10 {
            lastSeenLabel.text = "last seen at \(Data.lastSeenHours%12):0\(Data.lastSeenMinutes) " + checkAMorPM(number: Data.lastSeenHours)
        } else {
            lastSeenLabel.text = "last seen at \(Data.lastSeenHours%12):\(Data.lastSeenMinutes) " + checkAMorPM(number: Data.lastSeenHours)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changePractiseTime()
        changeLastSeen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeLastSeen), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
