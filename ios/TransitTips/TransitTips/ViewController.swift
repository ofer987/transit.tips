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

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var localButton : UIButton!
//    @IBOutlet weak var resultsText : UITextView!
    @IBOutlet weak var containerView : UIView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMockedSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
        // Do any additional setup after loading the view.
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
    }
    
    // MARK: Actions
    @IBAction func setSchedule(_ sender: UIButton) {
//        resultsText.text = ""
        setBusSchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
        setMockedSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
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
                        let schedule = try TrainJson.decode(result).toModel()
                        let transformedSchedule = TransformedModels.convertToSchedule(schedule)
                        
                        for station in transformedSchedule.stations {
                            self.containerView.addSubview(self.getStationView(station, 0))
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
                let schedule = try TrainJson.decode(result).toModel()
                let transformedSchedule = TransformedModels.convertToSchedule(schedule)
                
                var i = 0
                for station in transformedSchedule.stations {
                    self.containerView.addSubview(self.getStationView(station, i))
                    
                    i += 1
                }
                
//                for route in schedule.routes {
//                    self.containerView.addSubview(self.getRouteLabel(route))
//                }
            } catch {
                // do nothing
            }
            //                    self.resultsText.text += result
        }

    }

    func getStationView(_ station: TransformedModels.Station, _ i: Int) -> UIView {
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
    
    func getRouteView(_ line: TransformedModels.Line, x: Int = 0, y: Int = 0) -> UIView {
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
    
    func getArrivalsView(_ arrivals: [TransformedModels.Arrival], x: Int = 0, y: Int = 0) -> UIView {
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
//
//    func getRouteCount() -> Int {
//        return self.containerView.subviews.count
//    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
//        resultsText.text = "locations = \(location.coordinate.latitude) \(location.coordinate.longitude)"
    }
}
