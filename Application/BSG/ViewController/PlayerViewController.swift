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
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBAction func mediaPlay(_ sender: Any) {
        playMedia(status: false)
    }
    @IBAction func mediaPause(_ sender: Any) {
        playMedia(status: true)
    }

    @IBOutlet weak var speakerImage: UIImageView!
    @IBOutlet weak var mediaSubtitleLabel: UILabel!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var mediaStatusView: UIView!
    @IBOutlet weak var mediaStatusLabel: UILabel!
    
    @IBAction func mediaStatusViewButton(_ sender: Any) {
        if isPlaying == false{
            playMedia(status: true)
        } else {
            playMedia(status: false)
        }
    }
    
    var transitionTime = 0.6
    var isPlaying = false
    var timerStarted = false
    
    var timer = Timer()
    var player: AVAudioPlayer?
    
    func changeMediaControl(play: Bool, withName: String, withFormat: String) {
        guard let url = Bundle.main.url(forResource: withName, withExtension: withFormat) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            if play {
                player.play()
            } else {
                player.pause()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    @objc func updateTimer() {
        updatePractiseMinutes()
        seconds = seconds + 1
        if seconds < 10 {
            secondsLabel.text = "0\(seconds)"
        } else {
            secondsLabel.text = "\(seconds)"
        }
        if seconds == 59 {
            seconds = 0
            secondsLabel.text = "0\(seconds)"
            minutes = minutes + 1
            if minutes < 10 {
                minutesLabel.text = "0\(minutes)"
            } else {
                minutesLabel.text = "\(minutes)"
            }
        }
        if minutes == 59 {
            minutes = 0
            minutesLabel.text = "0\(minutes)"
            hours = hours + 1
            if hours < 10 {
                hoursLabel.text = "0\(hours)"
            } else {
                hoursLabel.text = "\(hours)"
            }
        }
    }
    
    func playMedia(status: Bool) {
        if status == true {
            isPlaying = true
            if timerStarted == false {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updateTimer), userInfo: nil, repeats: true)
                changeMediaControl(play: true, withName: AudioTrack.name, withFormat: AudioTrack.format)
                timerStarted = true
            }
            mediaStatusLabel.text = "Now Chanting..."
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: transitionTime) {
                self.mediaStatusView.backgroundColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
                self.speakerImage.image = UIImage.init(named: "speakerBlack")
                self.mediaTitleLabel.textColor = UIColor.black
                self.mediaSubtitleLabel.textColor = UIColor.black
                self.view.layoutIfNeeded()
            }
        } else {
            isPlaying = false
            if timerStarted == true {
                timer.invalidate()
                changeMediaControl(play: false, withName: AudioTrack.name, withFormat: AudioTrack.format)
                timerStarted = false
            }
            mediaStatusLabel.text = "Play to continue"
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: transitionTime) {
                self.mediaStatusView.backgroundColor = UIColor.init(red: 122/255, green: 199/255, blue: 77/255, alpha: 1)
                self.speakerImage.image = UIImage.init(named: "speakerGrey")
                self.mediaTitleLabel.textColor = UIColor.init(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
                self.mediaSubtitleLabel.textColor = UIColor.init(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func updatePractiseMinutes() {
        Data.totalPractiseMinutes = Data.totalPractiseMinutes + hours * 60 + minutes
    }

    override func viewDidAppear(_ animated: Bool) {
        seconds = 0
        minutes = 1
        hours = 0
        playMedia(status: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playMedia(status: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
