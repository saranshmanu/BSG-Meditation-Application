//
//  Data.swift
//  BSG
//
//  Created by Saransh Mittal on 22/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation

class AudioTrack {
    public static let name = "Track"
    public static let format = "mp3"
}

class CoreData {
    public static let lastSeenKey = "LastSeen"
    public static let practiseTimeKey = "LastPractisedSessionTime"
    public static let practiseDateKey = "LastPractisedSessionDate"
}

class Data {
    public static var totalPractiseMinutes = 0
    public static var lastSeenMinutes = 0
    public static var lastSeenHours = 0
    public static func loadCoreData() {
        self.loadPractiseTime()
        self.loadLastSeen()
    }
    public static func saveCoreData() {
        self.savePractiseTime()
        self.saveLastSeen()
    }
    public static func loadPractiseTime() {
        let currentPractisedSessionDate = Date()
        if let lastPractisedSessionDate = UserDefaults.standard.object(forKey: CoreData.practiseDateKey) {
            if Calendar.current.isDate(currentPractisedSessionDate, equalTo: lastPractisedSessionDate as! Date, toGranularity: .day) {
                let totalPractiseTime = UserDefaults.standard.object(forKey: CoreData.practiseTimeKey) as! Int
                totalPractiseMinutes = totalPractiseTime
            }
        }
    }
    public static func loadLastSeen() {
        if let lastSessionTime = UserDefaults.standard.object(forKey: CoreData.lastSeenKey) {
            let lastSessionDate = lastSessionTime as! Date
            lastSeenHours = Calendar.current.component(.hour, from: lastSessionDate)
            lastSeenMinutes = Calendar.current.component(.minute, from: lastSessionDate)
        }
    }
    public static func savePractiseTime() {
        UserDefaults.standard.set(Date(), forKey: CoreData.practiseDateKey)
        UserDefaults.standard.set(totalPractiseMinutes, forKey: CoreData.practiseTimeKey)
    }
    public static func saveLastSeen() {
        UserDefaults.standard.set(Date(), forKey: CoreData.lastSeenKey)
    }
}

func checkAMorPM(number: Int) -> String{
    if number < 12 {
        return "AM"
    } else {
        return "PM"
    }
}
