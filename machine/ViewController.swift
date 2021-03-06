//
//  ViewController.swift
//  machine
//
//  Created by Steven Than on 04/04/2018.
//  Copyright © 2018 Steven Than. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let machineId = 202
    var count = 0
    var apiTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCurrentReservation()
    }


    @objc func getCurrentReservation() -> Void {
        let url = "https://smart-marino.herokuapp.com/api/machines/\(machineId)/reservation?user=steven"
        Alamofire.request(url).responseJSON { response in
            if let rez = response.result.value as? Dictionary<String, String> {
                self.apiTimer.invalidate()
                self.performSegue(withIdentifier: "booked", sender: self)
            }
                
            self.apiTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getCurrentReservation), userInfo: nil, repeats: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

