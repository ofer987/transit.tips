// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

class TrainJson {
    enum ParserError: Error {
        case invalidJson
    }
    
    static func decode(_ rawData: String) throws -> Schedule {
        guard let jsonData = rawData.data(using: String.Encoding.utf8) else {
            throw ParserError.invalidJson
        }
        
        return try JSONDecoder().decode(TrainJson.Schedule.self, from: jsonData)
    }
    
    static func toModel(_ json: Schedule) -> ScheduleModel {
        return json.toModel()
    }

    // MARK: - Welcome
    struct Schedule: Codable {
        let longitude, latitude: Double
        let lines: [Line]
        
        func toModel() -> ScheduleModel {
            let result = ScheduleModel()
            result.requestedLocation = LocationModel(self.latitude, self.longitude)
            result.routes.append(contentsOf: lines.map{$0.toModel()})
            
            return result
        }
    }
    
    // MARK: - Line
    struct Line: Codable {
        let id: Int
        let name: String
        let stations: [Station]
        
        func toModel() -> RouteModel {
            let result = RouteModel()
            result.agencyId = "TTC"
            result.id = String(self.id)
            result.title = self.name
            result.stations.append(contentsOf: self.stations.map{$0.toModel()})
            
            return result
        }
    }
    
    // MARK: - Station
    struct Station: Codable {
        let id: Int
        let name: String
        let longitude, latitude: Double
        let directions: [Direction]
        
        func toModel() -> StationModel {
            let result = StationModel(self.name, LocationModel(self.longitude, self.latitude))
            result.directions.append(contentsOf: self.directions.map{$0.toModel()})
            
            return result
        }
    }
    
    // MARK: - Direction
    struct Direction: Codable {
        let destinationStation: String
        let events: [Event]
        
        enum CodingKeys: String, CodingKey {
            case destinationStation = "destination_station"
            case events
        }
        
        func toModel() -> DirectionModel {
            let result = DirectionModel()
            result.destinationStationName = destinationStation
            result.arrivals.append(contentsOf: self.events.map{$0.toPreciseModel()})
            
            return result
        }
    }
    
    // MARK: - Event
    struct Event: Codable {
        let approximatelyIn: String
        let preciselyIn: Double
        let message: String
        
        enum CodingKeys: String, CodingKey {
            case approximatelyIn = "approximately_in"
            case preciselyIn = "precisely_in"
            case message
        }
        
        func toModel() throws -> ArrivalModel {
            let minutes = Int(self.approximatelyIn)
            
            // TODO: verify that this throws an exception if approximatelyIn
            // does not decode to an Integer
            return ArrivalModel(minutes!, 0)
        }
        
        func toOptionalModel() -> ArrivalModel? {
            let maybeMinutes = Double(self.approximatelyIn)
            
            guard let minutes = maybeMinutes else {
                return nil
            }
            
            return ArrivalModel(Int(minutes), Int(minutes.truncatingRemainder(dividingBy: 1) * 60))
        }
        
        func toPreciseModel() -> ArrivalModel {
            let minutes = Int(self.preciselyIn)
            let seconds = Int(self.preciselyIn.truncatingRemainder(dividingBy: 1) * 60)
            
            return ArrivalModel(minutes, seconds)
        }
    }
}
