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

//    @IBOutlet weak var scrollView: UIScrollView!
    var locationManager: CLLocationManager!
    var trainsView: UIView!
    var busesView: UIView!
    var updated: Bool!
    
    @IBAction func openMainApp(_ sender: UIButton) {
        let appUrl = NSURL(string: "com.otium.TransitTips://fromTodayExtension")!
        extensionContext?.open(appUrl as URL, completionHandler: { (success) in
            if !success {
                // Do nothing for now
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.trainsView = UIView()
//        self.busesView = UIView()
        
//        self.scrollView.alwaysBounceVertical = true
//        self.scrollView.isScrollEnabled = true
//        self.scrollView.showsVerticalScrollIndicator = true
//
        let openMainAppButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 1000, height: 36))
        openMainAppButton.backgroundColor = .red
        openMainAppButton.translatesAutoresizingMaskIntoConstraints = false
        openMainAppButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        openMainAppButton.widthAnchor.constraint(equalToConstant: 1000).isActive = true
        openMainAppButton.addTarget(self, action: #selector(openMainApp(_:)), for: .touchDown)
        //openMainAppButton.addGestureRecognizer(UIGestureRecognizer(target: self, action: Selector(("openMainApp:"))))
        
        self.view.addSubview(openMainAppButton)
        self.view.frame = CGRect(x: 0.0, y: 0.0, width: 1000, height: 750)
        self.trainsView = UIView(frame: CGRect(x: 0, y: 36, width: 500, height: 250))
        self.view.addSubview(trainsView)
//        self.scrollView.addSubview(trainsView)
//
        self.busesView = UIView(frame: CGRect(x: 0, y: 200, width: 500, height: 500))
        self.view.addSubview(busesView)
        
        self.updated = false
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
//            locationManager.requestLocation()
        }
//        setMockedSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize(width: 359, height: 1000)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func addScheduleViews(_ views: [UIView] = [UIView]()) {
        let initialHeight = Double(self.view.subviews.last?.frame.maxY ?? 0)
        var maxY = initialHeight
        
        for view in views {
            maxY += Double(view.frame.maxY)
        }
        
        self.view.frame = CGRect(x: 0.0, y: 0.0, width: 1000, height: maxY)
        self.preferredContentSize = CGSize(width: 1000, height: maxY)
        
        var startY = initialHeight
        for view in views {
            let height = Double(view.frame.maxY)
            let container = UIView(
                frame: CGRect(
                    x: 0.0,
                    y: startY,
                    width: 1000.0,
                    height: height
                )
            )
            container.addSubview(view)
            self.view.addSubview(container)
            
            startY = height
        }
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
                    do {
                        let schedule = try BusJson.toModel(BusJson.decode(result))
                        
                        var startX = 0.0
                        var startY = 0.0
                        var i = 0
                        var stationViews = [UIView]()
                        for station in schedule.stations {
                            let stationView = self.getStationView(station, x: Int(startX), y: Int(startY))
                            stationViews.append(stationView)

                            startX = Double(stationView.frame.maxX)
                            startY = Double(stationView.frame.maxY)
                            
                            i += 1
                        }
                        
//                        self.busesView = UIView(
//                            frame: CGRect(
//                                x: 0.0,
//                                y: 0.0,
//                                width: stationViews.last?.frame.maxX ?? 0.0,
//                                height: stationViews.last?.frame.maxY ?? 0.0
//                            )
//                        )
                        
                        for view in stationViews {
                            self.busesView.addSubview(view)
                        }
                        
//                        self.addScheduleViews([self.busesView])
                    } catch {
                        // do nothing
                    }
                    //                    self.resultsText.text += result
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
                    do {
                        let schedule = try TrainJson.toModel(TrainJson.decode(result))
                        
                        var startX = 0.0
                        var startY = 0.0
                        var i = 0
                        var stationViews = [UIView]()
                        for station in schedule.stations {
                            let stationView = self.getStationView(station, x: Int(startX), y: Int(startY))
                            stationViews.append(stationView)
                            
                            startX = Double(stationView.frame.maxX)
                            startY = Double(stationView.frame.maxY)
                            
                            i += 1
                        }
                        
//                        self.trainsView = UIView(
//                            frame: CGRect(
//                                x: 0.0,
//                                y: 0.0,
//                                width: stationViews.last?.frame.maxX ?? 0.0,
//                                height: stationViews.last?.frame.maxY ?? 0.0
//                            )
//                        )
                        
                        for view in stationViews {
                            self.trainsView.addSubview(view)
                        }
                        
//                        self.addScheduleViews([self.trainsView])
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
//                    self.scrollView.addSubview(self.getStationView(station, i))
                    
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
    
    func getStationView(_ station: Common_Models.Station, x: Int = 0, y: Int = 0) -> UIView {
        var views = [UIView]()
//        let lineCount = station.lines.count
//        let container = UIView(frame: CGRect(x: 0, y: y, width: 1000, height: 20 + lineCount * 40))
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 20))
        nameLabel.textAlignment = .left
        nameLabel.text = station.name
        views.append(nameLabel)
//        container.addSubview(nameLabel)
        
        var startX = 0.0
        var startY = 20.0
        for line in station.lines {
            let routeView = getRouteView(line, x: Int(startX), y: Int(startY))
            views.append(routeView)
//            container.addSubview(routeView)
            
            startX = Double(routeView.frame.maxX)
            startY = Double(routeView.frame.maxY)
        }
        
        let maxX = 1000.0
        let maxY = Double(views.last?.frame.maxY ?? 0)
        let container = UIView(frame: CGRect(x: 0.0, y: Double(y), width: maxX, height: maxY))
        
        for view in views {
            container.addSubview(view)
        }
        
        // NOTE: should we redraw the container's frame?
        // NOTE: YES
        
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
        var j = 0
        var views = [UIView]()
        for direction in line.directions {
            let lineLabel = UILabel(frame: CGRect(x: 10, y: 40*j, width: 1000, height: 20))
            lineLabel.textAlignment = .justified
            lineLabel.text = "Line \(line.id) to \(direction.destinationStationName)"
//            container.addSubview(lineLabel)
            views.append(lineLabel)
            
            let arrivalsView = getArrivalsView(direction.arrivals, x: 10, y: 20 + 40*j)
            views.append(arrivalsView)
//            container.addSubview(arrivalsView)
            j += 1
        }
        
        let maxX = 0.0
        let maxY = Double(views.last?.frame.maxY ?? 0)
        let container = UIView(frame: CGRect(x: 0.0, y: Double(y), width: maxX, height: maxY))
        for view in views {
            container.addSubview(view)
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
        let container = UIView(frame: CGRect(x: x, y: y, width: 1000, height: 20))
        
        var i = 0
        for arrival in arrivals {
            let label = UILabel(frame: CGRect(x: 20 + 20*i, y: 0, width: 100, height: 20))
            label.textAlignment = .center
            label.text = "\(arrival.minutes)"
            
            container.addSubview(label)
            i += 1
        }
        
        return container
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if self.updated {
            return
        }
        self.updated = true
        
        let location = locations.last! as CLLocation
        setSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)")
        
        setBusSchedule("https://restbus.transit.tips?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)")
//        setSubwaySchedule("https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.6427628186868&longitude=-79.38223111800772")
        
        //        resultsText.text = "locations = \(location.coordinate.latitude) \(location.coordinate.longitude)"
    }
}
