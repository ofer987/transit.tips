//
//  ViewController.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-15.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var localButton : UIButton!
    @IBOutlet weak var resultsText : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func setSchedule(_ sender: UIButton) {
        let results = [ "Line1", "Line 2" ]
    setBusSchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
    }
    
    func setBusSchedule(_ path: String) {
        let url = URL(string: path)
        if let absoluteUrl = url?.absoluteURL {
            let task = URLSession.shared.dataTask(with: absoluteUrl) { (data, response, error) in
                guard let data = data else {
                    self.resultsText.text = "COULD NOT GET DATA"
                    return
                }
                
                self.resultsText.text = String(data: data, encoding: .utf8)!
            }
            task.resume()
        }
    }
}
