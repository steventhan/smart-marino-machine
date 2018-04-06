//
//  TimerViewController.swift
//  machine
//
//  Created by Steven Than on 2018/4/5.
//  Copyright © 2018 Steven Than. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMoment

class TimerViewController: UIViewController {
    let machineId = 202
    
    var timer = Timer()

    var end = moment() {
        didSet {
            self.timer.invalidate()
            self.timer = Timer()
            self.calTimeLeft(withEndTime: self.end)
        }
    }


    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCurrentReservation()
    }
    
    func calTimeLeft(withEndTime end : Moment) {
        var timeLeft = end - moment()

        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            timeLeft = timeLeft - 1.seconds
            self.timerLabel.text = timeLeft.description
        })
        
    }
    
    @objc func getCurrentReservation() -> Void {
        let url = "https://smart-marino.herokuapp.com/api/machines/\(machineId)/reservation?user=steven"
        Alamofire.request(url).responseJSON { response in
            if let rez = response.result.value as? Dictionary<String, String> {
                if let status = rez["status"], status != "started" {
                    self.performSegue(withIdentifier: "rezEnded", sender: self)
                }
                
                if let endString = rez["end"] {
                    if let end = moment(endString), end != self.end {
                       self.end = end
                    }
                }
            } else {
                self.performSegue(withIdentifier: "rezEnded", sender: self)
            }

            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.getCurrentReservation), userInfo: nil, repeats: false)
        }
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

}
