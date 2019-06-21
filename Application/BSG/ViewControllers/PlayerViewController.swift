//
//  PlayerViewController.swift
//  BSG
//
//  Created by Saransh Mittal on 19/06/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var player: AVAudioPlayer?
    var startedToPlay = false
    
    var isPlaying:Bool = false
    var timerStarted = false
    var time = 0.6
    var sec=0
    var min=0
    var hour=0
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Track", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pauseSound(){
        guard let url = Bundle.main.url(forResource: "track", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.pause()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var hours: UILabel!
    var timer = Timer()
    
    @objc func action(){
        sec+=1
        if sec <= 9{
            seconds.text = "0" + String(sec)
        } else {
            seconds.text = String(sec)
        }
        
        if sec==59{
            sec=0
            seconds.text = "0" + String(sec)
            min+=1
            if min <= 9{
                minutes.text = "0" + String(min)
            } else {
                minutes.text = String(min)
            }
        }
        if min==59{
            min=0
            minutes.text = "0" + String(min)
            hour+=1
            if hour <= 9{
                hours.text = "0" + String(hour)
            } else {
                hours.text = String(hour)
            }
        }
    }
    
    var totalPractisedMinutesOfToday = 0
    
    @objc func loadSession(){
        let currentDate = Date()
        let calendar = Calendar.current
        var previousMinutes = 0
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
                        }
                    }
                }
            }
        }
    }
    
    @objc func saveSession(){
        totalPractisedMinutesOfToday = totalPractisedMinutesOfToday + hour * 60 + min
        saveLastPractised()
    }
    
    func saveLastPractised(){
        let defaults = UserDefaults.standard
        let currentDate = Date()
        let calendar = Calendar.current
        var practisedDay = calendar.component(.day, from: currentDate)
        var practisedMonth = calendar.component(.month, from: currentDate)
        var practisedYear = calendar.component(.year, from: currentDate)
        defaults.set(String(totalPractisedMinutesOfToday), forKey: lastPractised.minutes)
        defaults.set(String(practisedDay), forKey: lastPractised.day)
        defaults.set(String(practisedMonth), forKey: lastPractised.month)
        defaults.set(String(practisedYear), forKey: lastPractised.year)
    }
    
    func playAction(){
        isPlaying = true
        if timerStarted == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.action), userInfo: nil, repeats: true)
            playSound()
            timerStarted = true
        }
        bottomPlayDescription.text = "Now Chanting..."
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: time) {
            self.bottomBarBackgroundBarColor.backgroundColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
            self.speakerImage.image = UIImage.init(named: "speakerBlack")
            self.textOne.textColor = UIColor.black
            self.textTwo.textColor = UIColor.black
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pauseButtonAction(_ sender: Any) {
        stopAction()
    }
    @IBAction func playButtonAction(_ sender: Any) {
        playAction()
    }
    
    func stopAction(){
        isPlaying = false
        if timerStarted == true {
            timer.invalidate()
            pauseSound()
            timerStarted = false
        }
        bottomPlayDescription.text = "Play to continue"
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: time) {
            self.bottomBarBackgroundBarColor.backgroundColor = UIColor.init(red: 122/255, green: 199/255, blue: 77/255, alpha: 1.0)
            self.speakerImage.image = UIImage.init(named: "speakerGrey")
            self.textOne.textColor = UIColor.init(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            self.textTwo.textColor = UIColor.init(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sec=0
        min=0
        hour=0
        totalPractisedMinutesOfToday = 0
        loadSession()
        stopAction()
    }
    override func viewDidDisappear(_ animated: Bool) {
        saveSession()
        stopAction()
    }

    @IBOutlet weak var textTwo: UILabel!
    @IBOutlet weak var textOne: UILabel!
    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var bottomBarBackgroundBarColor: UIView!
    @IBOutlet weak var bottomPlayDescription: UILabel!
    
    @IBAction func bottonPlayButton(_ sender: Any) {
        if isPlaying == false{
            playAction()
        } else {
            stopAction()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveSession), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.saveSession), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSession), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }

}
