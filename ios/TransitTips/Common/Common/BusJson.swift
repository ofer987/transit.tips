//
//  BusJson.swift
//  Common
//
//  Created by Dan Jakob Ofer on 2019-07-11.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import Common_Models

public class BusJson {
    
    enum ParserError: Error {
        case invalidJson
    }
    
    public static func decode(_ rawData: String) throws -> Welcome {
        guard let jsonData = rawData.data(using: String.Encoding.utf8) else {
            throw ParserError.invalidJson
        }
        
        return try JSONDecoder().decode(BusJson.Welcome.self, from: jsonData)
    }
    
    public static func toModel(_ json: Welcome) -> Common_Models.Schedule {
        return convertToSchedule(json)
    }
    
    public static func convertToSchedule(_ source: Welcome) -> Common_Models.Schedule {
        
        let location = convertToLocation(source.address, latitude: source.latitude, longitude: source.longitude)
        let result = Common_Models.Schedule(location)

        var allStations = [String:Common_Models.Station]()
        //let allStops = source.routes.flatMap({$0.stop})
        
        for route in source.routes {
            if let station = allStations[route.stop.id] {
                station.lines.append(convertToLine(route))
            } else {
                let id = Int(route.stop.id) ?? 0
                let name = route.stop.title
                // TODO: change with null Location
                let address = Common_Models.Location(latitude: 0.0, longitude: 0.0)
                let station = Common_Models.Station(id, name, address)
                allStations[route.stop.id] = station
                station.lines.append(convertToLine(route))
            }
        }

        result.stations.append(contentsOf: allStations.values)
        
        return result
    }
    
    static func convertToLine(_ route: RouteElement) -> Common_Models.Line {
        var id = 0
        if let unwrappedId = route.route.id {
            id = Int(unwrappedId) ?? 0
        }
        let result = Common_Models.Line(id, route.route.title)
        
        for value in route.values {
            let direction = Common_Models.Direction(value.direction.title)
            direction.arrivals.append(Arrival(value.minutes, value.seconds))
            
            result.directions.append(direction)
        }
        
        return result
    }
    
    static func convertToLocation(_ address: String, latitude: Double, longitude: Double) -> Common_Models.Location {
        return Common_Models.Location(latitude: latitude, longitude: longitude)
    }
    
    public init() {
    }
    
    // MARK: - Welcome
    public struct Welcome: Codable {
        let latitude, longitude: Double
        let routes: [RouteElement]
        let address: String
    }
    
    // MARK: - RouteElement
    struct RouteElement: Codable {
        let agency: Agency
        let route: DirectionClass
        let stop: Stop
        let messages: [JSONAny]
        let values: [Value]
        let links: Links
        
        enum CodingKeys: String, CodingKey {
            case agency, route, stop, messages, values
            case links = "_links"
        }
    }
    
    // MARK: - Agency
    struct Agency: Codable {
        let id: ID
        let title: Title
        let logoURL: LogoURL
        
        enum CodingKeys: String, CodingKey {
            case id, title
            case logoURL = "logoUrl"
        }
    }
    
    enum ID: String, Codable {
        case ttc = "ttc"
    }
    
    enum LogoURL: String, Codable {
        case logosTorontoLogoGIF = "/logos/torontoLogo.gif"
    }
    
    enum Title: String, Codable {
        case torontoTTC = "Toronto TTC"
    }
    
    // MARK: - Links
    struct Links: Codable {
        let linksSelf: SelfClass
        let to, from: [JSONAny]
        
        enum CodingKeys: String, CodingKey {
            case linksSelf = "self"
            case to, from
        }
    }
    
    // MARK: - SelfClass
    struct SelfClass: Codable {
        let href: String
        let type: TypeEnum
        let rel: Rel
        let rt: Rt
        let title: String
    }
    
    enum Rel: String, Codable {
        case relSelf = "self"
    }
    
    enum Rt: String, Codable {
        case prediction = "prediction"
    }
    
    enum TypeEnum: String, Codable {
        case applicationJSON = "application/json"
    }
    
    // MARK: - DirectionClass
    struct DirectionClass: Codable {
        let id: String?
        let title: String
    }
    
    // MARK: - Stop
    struct Stop: Codable {
        let id, title, distance: String
    }
    
    // MARK: - Value
    struct Value: Codable {
        let epochTime: JSONNull?
        let seconds, minutes: Int
        let branch, isDeparture: JSONNull?
        let affectedByLayover: Bool
        let isScheduleBased, vehicle: JSONNull?
        let direction: DirectionClass
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }
}
