//
//  HomeViewController.swift
//  BSG
//
//  Created by Saransh Mittal on 17/06/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var practiseDurationLabel: UILabel!
    let healthStore = HKHealthStore()
    let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
    
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
    
    func saveHealthData(minutes: Double) {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(minutes * 60.0)
        saveMindfullAnalysis(startTime: startTime, endTime: endTime)
    }
    func activateHealthKit() {
        let typestoRead = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!])
        let typestoShare = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!])
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if !success{
                print("HealthKit Auth error\(String(describing: error))")
            }
        }
    }
    func saveMindfullAnalysis(startTime: Date, endTime: Date) {
        let mindfullSample = HKCategorySample(type:mindfulType!, value: 0, start: startTime, end: endTime)
        healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
            if error != nil {return}
            print("New data was saved in HealthKit: \(success)")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changePractiseTime()
        changeLastSeen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateHealthKit()
        saveHealthData(minutes: 10)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeLastSeen), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
