//
//  TodayViewController.swift
//  TransitTipsToday
//
//  Created by Dan Jakob Ofer on 2019-07-07.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NotificationCenter
import Common
import Common_Models

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var locationManager: CLLocationManager!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsVerticalScrollIndicator = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.preferredContentSize = CGSize(width: 359, height: 200)
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
//        setMockedSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize(width: 359, height: 400)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
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
                
                //                DispatchQueue.main.async {
                //                    self.resultsText.text += result
                //                }
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
                    do {
                        let schedule = try TrainJson.toModel(TrainJson.decode(result))
                        
                        for station in schedule.stations {
                            self.scrollView.addSubview(self.getStationView(station, 0))
                        }
                    } catch {
                        // do nothing
                    }
                    //                    self.resultsText.text += result
                }
            }
            task.resume()
        }
    }
    
    func setMockedSubwaySchedule(_ path: String) {
        let result = "{\"longitude\":-79.38223111800772,\"latitude\":43.6427628186868,\"lines\":[{\"id\":1,\"name\":\"Yonge-University-Spadina\",\"stations\":[{\"id\":16,\"name\":\"Union\",\"longitude\":-79.380861,\"latitude\":43.6452239,\"directions\":[{\"destination_station\":\"Finch\",\"events\":[{\"approximately_in\":\"04.00\",\"precisely_in\":3.4162369811320756,\"message\":\"Arriving\"},{\"approximately_in\":\"07.00\",\"precisely_in\":6.193583773584905,\"message\":\"Arriving\"},{\"approximately_in\":\"11.00\",\"precisely_in\":10.795033584905658,\"message\":\"Arriving\"}]},{\"destination_station\":\"Vaughan Metropolitan Centre\",\"events\":[{\"approximately_in\":\"05.00\",\"precisely_in\":4.240761509433963,\"message\":\"Arriving\"},{\"approximately_in\":\"07.00\",\"precisely_in\":6.556557735849056,\"message\":\"Arriving\"},{\"approximately_in\":\"13.00\",\"precisely_in\":12.3519079245283,\"message\":\"Arriving\"}]}]}]}]}"
        
        DispatchQueue.main.async {
            do {
                let schedule = try TrainJson.toModel(TrainJson.decode(result))
                
                var i = 0
                for station in schedule.stations {
                    self.scrollView.addSubview(self.getStationView(station, i))
                    
                    i += 1
                }
                
                //                for route in schedule.routes {
                //                    self.scrollView.addSubview(self.getRouteLabel(route))
                //                }
            } catch {
                // do nothing
            }
            //                    self.resultsText.text += result
        }
        
    }
    
    func getStationView(_ station: Common_Models.Station, _ i: Int) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0 + 20*i, width: 1000, height: 200))
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 20))
        nameLabel.textAlignment = .left
        nameLabel.text = station.name
        container.addSubview(nameLabel)
        
        var i = 0
        for line in station.lines {
            container.addSubview(getRouteView(line, y: 50*i))
            i += 1
        }
        
        return container
        
        //        for direction in station.directions {
        //
        //            let text = "\(station.name) to \(direction.destinationStationName)"
        //
        //            let label = UILabel(frame: CGRect(
        //                x: 100,
        //                y: 50 + 20*getRouteCount(),
        //                width: 400,
        //                height: 21))
        //            //                            label.center = CGPoint(x: 160, y: 285 + 20*count)
        //            label.textAlignment =  .left
        //            label.text = text
        //
        //            label.addSubview(getArrivalsLabel(direction))
        //
        //            return label
        //        }
        //
        //        return UILabel()
    }
    
    func getRouteView(_ line: Common_Models.Line, x: Int = 0, y: Int = 0) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 20 + y, width: 1000, height: 20))
        
        var j = 0
        for direction in line.directions {
            let lineLabel = UILabel(frame: CGRect(x: 10, y: 40*j, width: 1000, height: 20))
            lineLabel.textAlignment = .justified
            lineLabel.text = "Line \(line.id) to \(direction.destinationStationName)"
            container.addSubview(lineLabel)
            
            container.addSubview(getArrivalsView(direction.arrivals, x: 10, y: 40*j))
            j += 1
        }
        
        return container
    }
    
    //    func getArrivalsLabel(_ direction: DirectionModel) -> UILabel {
    //        let text = direction.arrivals
    //            .map({ "(\($0.minutes):\($0.seconds))" })
    //            .joined(separator: ", ")
    //
    //        let label = UILabel(frame: CGRect(
    //            x: 0,
    //            y: 30,
    //            width: 200,
    //            height: 21))
    //        //                            label.center = CGPoint(x: 160, y: 285 + 20*count)
    //        label.textAlignment =  .center
    //        label.text = text
    //
    //        return label
    //    }
    
    func getArrivalsView(_ arrivals: [Common_Models.Arrival], x: Int = 0, y: Int = 0) -> UIView {
        let container = UIView(frame: CGRect(x: x + 50, y: 20 + y, width: 1000, height: 20))
        
        var i = 0
        for arrival in arrivals {
            let label = UILabel(frame: CGRect(x: 20 + 60*i, y: 0, width: 60, height: 20))
            label.textAlignment = .center
            label.text = "(\(arrival.minutes):\(arrival.seconds))"
            
            container.addSubview(label)
            i += 1
        }
        
        return container
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        setSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)")
        
//        setSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
        
        //        resultsText.text = "locations = \(location.coordinate.latitude) \(location.coordinate.longitude)"
    }
}
