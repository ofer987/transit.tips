//
//  ViewController.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-15.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: Properties
    @IBOutlet weak var localButton : UIButton!
    @IBOutlet weak var resultsText : UITextView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Actions
    @IBAction func setSchedule(_ sender: UIButton) {
        resultsText.text = ""
        setBusSchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
        setSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
    }
    
    func setBusSchedule(_ path: String) {
        let url = URL(string: path)
        if let absoluteUrl = url?.absoluteURL {
            let task = URLSession.shared.dataTask(with: absoluteUrl) { (data, response, error) in
                var result: String
                if let data = data {
                    result = String(data: data, encoding: .utf8)!
                } else {
                    result = "COULD NOT GET DATA"
                }
                
                DispatchQueue.main.async {
                    self.resultsText.text += result
                }
            }
            task.resume()
        }
    }
    
    func setSubwaySchedule(_ path: String) {
        let url = URL(string: path)
        if let absoluteUrl = url?.absoluteURL {
            let task = URLSession.shared.dataTask(with: absoluteUrl) { (data, response, error) in
                var result: String
                if let data = data {
                    result = String(data: data, encoding: .utf8)!
                } else {
                    result = "COULD NOT GET DATA"
                }
                
                DispatchQueue.main.async {
                    self.resultsText.text += result
                }
            }
            task.resume()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        resultsText.text = "locations = \(location.coordinate.latitude) \(location.coordinate.longitude)"
    }
}
