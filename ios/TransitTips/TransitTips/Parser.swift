//
//  Parser.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case invalidJson
}

// TODO:
// 1. Rename to Buses
// 2. Make it instantiable
// 3. Subclass Decodable
// 4. Make it create the Schedule. Route, et cetera models
// 5. Refactor Schedule.Kye and Route.Key here because they are Buses' concerns
class Parser {
    static func parseBusSchedule(_ rawData: String) -> NSDictionary {
        guard let jsonData = rawData.data(using: String.Encoding.utf8) else {
            return NSDictionary()
        }
        
        guard let parsedData = try? JSONSerialization.jsonObject(with: jsonData) as? NSDictionary else {
            return NSDictionary()
        }
        
        return parsedData
    }
    
    static func decodeSchedule(_ rawData: String) throws -> Schedule {
        guard let jsonData = rawData.data(using: String.Encoding.utf8) else {
            throw ParserError.invalidJson
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(Schedule.self, from: jsonData)
        
        return result
    }
}
