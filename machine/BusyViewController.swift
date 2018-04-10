//
//  BusyViewController.swift
//  machine
//
//  Created by Steven Than on 2018/4/9.
//  Copyright © 2018 Steven Than. All rights reserved.
//

import UIKit
import Alamofire

class BusyViewController: UIViewController {

    let machineId = 202
    var apiTimer = Timer()
    
    @IBOutlet weak var checkInCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.get()
    }
    
    
    @objc func get() -> Void {
        let url = "https://smart-marino.herokuapp.com/api/machines/\(machineId)/reservation?user=steven"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let rez = response.result.value as? Dictionary<String, String> {
                    if let code = rez["code"] {
                        self.checkInCode.text = code
                    }
                    if let status = rez["status"], status == "started" {
                        
                        self.apiTimer.invalidate()
                        self.performSegue(withIdentifier: "rezStarted", sender: self)
                    }
                }
            case .failure(let _):
                self.apiTimer.invalidate()
                self.performSegue(withIdentifier: "rezCancelled", sender: self)
            }
            
            self.apiTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.get), userInfo: nil, repeats: false)
            
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
