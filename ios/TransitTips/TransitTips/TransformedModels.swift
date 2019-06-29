//
//  TransformedModels.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-29.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class TransformedModels {
    static func convertToSchedule(_ source: ScheduleModel) -> Schedule {
        let result = Schedule(source.requestedLocation)
        
        let stationModels = source.routes.flatMap({$0.stations})
        
        var stationModelsById: [String: StationModel] = [:]
        for stationModel in stationModels {
            let key = stationModel.name
            if case nil = stationModelsById[key] {
                stationModelsById[key] = stationModel
            }
        }
        
        for stationModel in stationModelsById.values {
            let station = convertToStation(stationModel)
            
            result.stations.append(station)
        }
        
        for routeModel in source.routes {
            for stationModel in routeModel.stations {
                // Or maybe I just count the amount of stations?
                // Or maybe I ask if stations has the value?
                if let station = result.stations.first(where: { $0.name == stationModel.name }) {
                    let line = convertToLine(routeModel)
                    
                    station.lines.append(line)
                    
                    for directionModel in stationModel.directions {
                        let direction = convertToDirection(directionModel)
                        line.directions.append(direction)
                        
                        direction.arrivals.append(
                            contentsOf: directionModel.arrivals.map({convertToArrival($0)})
                        )
                    }
                }
            }
        }
        
        return result
    }
    
    static func convertToStation(_ source: StationModel) -> Station {
        return Station(0, source.name, source.location)
    }
    
    static func convertToLine(_ source: RouteModel) -> Line {
        return Line(Int(source.id) ?? 0, source.title)
    }
    
    static func convertToDirection(_ source: DirectionModel) -> Direction {
        return Direction(source.destinationStationName)
    }
    
    static func convertToArrival(_ source: ArrivalModel) -> Arrival {
        return Arrival(source.minutes, source.seconds)
    }
    
    class Schedule {
        var requestedAddress: LocationModel
        var stations: [Station] = [Station]()
        
        init(_ requestedAddress: LocationModel) {
            self.requestedAddress = requestedAddress
        }
    }
    
    class Station {
        var lines: [Line] = [Line]()
        var id: Int = 0
        var name: String = ""
        var address: LocationModel
        
        init(_ id: Int, _ name: String, _ address: LocationModel) {
            self.id = id
            self.name = name
            self.address = address
        }
        
        func isValid() -> Bool {
            return true
        }
    }
    
    class Line {
        var directions: [Direction] = [Direction]()
        var id: Int = 0
        var name: String = ""
        
        init(_ id: Int, _ name: String) {
            self.id = id
            self.name = name
        }
        
        func isValid() -> Bool {
            return true
        }
    }
    
    class Direction {
        var arrivals: [Arrival] = [Arrival]()
        var destinationStationName: String = ""
        
        init(_ destinationStationName: String) {
            self.destinationStationName = destinationStationName
        }
    }
    
    class Arrival {
        var minutes: Int = 0
        var seconds: Int = 0
        
        init(_ minutes: Int, _ seconds: Int) {
            self.minutes = minutes
            self.seconds = seconds
        }
    }
}
