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
        
        resultsText.text = results.joined(separator: ", ")
    }
}
