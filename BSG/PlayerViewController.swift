//
//  PlayerViewController.swift
//  BSG
//
//  Created by Saransh Mittal on 19/06/18.
//  Copyright © 2018 Saransh Mittal. All rights reserved.
//

import UIKit

var practisedMinutes = 0

class PlayerViewController: UIViewController {
    var isPlaying:Bool = false
    var timerStarted = false
    var time = 0.6
    var sec=0
    var min=0
    var hour=0
    
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
        
        if sec==60{
            sec=0
            min+=1
            if min <= 9{
                minutes.text = "0" + String(min)
            } else {
                minutes.text = String(min)
            }
        }
        if min==60{
            min=0
            hour+=1
            if hour <= 9{
                hours.text = "0" + String(hour)
            } else {
                hours.text = String(hour)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if hour >= 1{
            practisedMinutes = practisedMinutes*hour
        }
        practisedMinutes = practisedMinutes + min
    }
    
    func playAction(){
        isPlaying = true
        if timerStarted == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.action), userInfo: nil, repeats: true)
            timerStarted = true
        }
        bottomPlayDescription.text = "Now Chanting.."
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
        stopAction()
    }
    override func viewDidDisappear(_ animated: Bool) {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
