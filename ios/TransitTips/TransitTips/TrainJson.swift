// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import Common_Models

public class TrainJson {
    enum ParserError: Error {
        case invalidJson
    }
    
    public static func decode(_ rawData: String) throws -> Schedule {
        guard let jsonData = rawData.data(using: String.Encoding.utf8) else {
            throw ParserError.invalidJson
        }
        
        return try JSONDecoder().decode(TrainJson.Schedule.self, from: jsonData)
    }
    
    public static func toModel(_ json: Schedule) -> Common_Models.Schedule {
        return json.toModel()
    }
    
    public init() {        
    }
    
    // MARK: - Welcome
    public struct Schedule: Codable {
        let longitude, latitude: Double
        let lines: [Line]
        
        public init() {
            self.longitude = 0
            self.latitude = 0
            self.lines = [Line]()
        }
        
        public func toModel() -> Common_Models.Schedule {
            return convertToSchedule(self)
        }
    }
    
    // MARK: - Line
    public struct Line: Codable {
        public let id: Int
        public let name: String
        public let stations: [Station]
        
        public init() {
            self.id = 0
            self.name = "TTC"
            self.stations = [Station]()
        }
    }
    
    // MARK: - Station
    public struct Station: Codable {
        let id: Int
        let name: String
        let longitude, latitude: Double
        let directions: [Direction]
        
        public init() {
            self.id = 0
            self.name = ""
            self.longitude = 0
            self.latitude = 0
            self.directions = [Direction]()
        }
    }
    
    // MARK: - Direction
    public struct Direction: Codable {
        public let destinationStation: String
        public let events: [Event]
        
        enum CodingKeys: String, CodingKey {
            case destinationStation = "destination_station"
            case events
        }
        
        public init() {
            self.destinationStation = ""
            self.events = [Event]()
        }
    }
    
    // MARK: - Event
    public struct Event: Codable {
        let approximatelyIn: String
        let preciselyIn: Double
        let message: String
        
        enum CodingKeys: String, CodingKey {
            case approximatelyIn = "approximately_in"
            case preciselyIn = "precisely_in"
            case message
        }
        
        public init() {
            self.approximatelyIn = ""
            self.preciselyIn = 0
            self.message = ""
        }
        
        public func toModel() throws -> Common_Models.Arrival {
            let minutes = Int(self.approximatelyIn)
            
            // TODO: verify that this throws an exception if approximatelyIn
            // does not decode to an Integer
            return Common_Models.Arrival(minutes!, 0)
        }
        
        public func toOptionalModel() -> Common_Models.Arrival? {
            let maybeMinutes = Double(self.approximatelyIn)
            
            guard let minutes = maybeMinutes else {
                return nil
            }
            
            return Common_Models.Arrival(Int(minutes), Int(minutes.truncatingRemainder(dividingBy: 1) * 60))
        }
        
        public func toPreciseModel() -> Common_Models.Arrival {
            let minutes = Int(self.preciselyIn)
            let seconds = Int(self.preciselyIn.truncatingRemainder(dividingBy: 1) * 60)
            
            return Common_Models.Arrival(minutes, seconds)
        }
    }
    
    public static func convertToSchedule(_ source: Schedule) -> Common_Models.Schedule {
        let result = Common_Models.Schedule(Common_Models.Location(latitude: source.latitude, longitude: source.longitude))
        
        let stations = source.lines.flatMap({$0.stations})
        
        var stationsById: [String: Station] = [:]
        for station in stations {
            let key = station.name
            if case nil = stationsById[key] {
                stationsById[key] = station
            }
        }
        
        for station in stationsById.values {
            result.stations.append(convertToStation(station))
        }
        
        for line in source.lines {
            for station in line.stations {
                // Or maybe I just count the amount of stations?
                // Or maybe I ask if stations has the value?
                if let existingStation = result.stations.first(where: { $0.name == station.name }) {
                    let lineModel = convertToLine(line)
                    
                    existingStation.lines.append(lineModel)
                    
                    for directionModel in station.directions {
                        let direction = convertToDirection(directionModel)
                        lineModel.directions.append(direction)
                        
                        for event in directionModel.events {
                            if let arrival = convertToArrival(event) {
                                direction.arrivals.append(arrival)
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    static func convertToStation(_ source: Station) -> Common_Models.Station {
        let location = convertToLocation(
            latitude: source.latitude,
            longitude: source.longitude
        )
        
        return Common_Models.Station(0, source.name, location)
    }
    
    static func convertToLine(_ source: Line) -> Common_Models.Line {
        return Common_Models.Line(Int(source.id), source.name)
    }
    
    static func convertToDirection(_ source: Direction) -> Common_Models.Direction {
        return Common_Models.Direction(source.destinationStation)
    }
    
    static func convertToArrival(_ source: Event) -> Common_Models.Arrival? {
        return try source.toOptionalModel()
    }
    
    static func convertToLocation(latitude: Double, longitude: Double) -> Common_Models.Location {
        return Common_Models.Location(latitude: latitude, longitude: longitude)
    }
}
