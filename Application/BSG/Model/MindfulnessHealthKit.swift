//
//  MindfulnessHealthKit.swift
//  BSG
//
//  Created by Saransh Mittal on 23/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import HealthKit

class MindfulnessHealthKit {
    public static let healthStore = HKHealthStore()
    public static let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)

    public static func activateHealthKit() {
        let typestoRead = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!])
        let typestoShare = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!])
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if !success{
                print("HealthKit Auth error\(String(describing: error))")
            }
        }
    }
    public static func saveMindfullAnalysis(startTime: Date, endTime: Date) {
        let mindfullSample = HKCategorySample(type:mindfulType!, value: 0, start: startTime, end: endTime)
        healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
            if error != nil {return}
            print("New data was saved in HealthKit: \(success)")
        })
    }
}
