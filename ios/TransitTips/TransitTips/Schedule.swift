//
//  Schedule.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class Schedule : Decodable {
    struct Key : CodingKey {
        var stringValue: String
        init(stringValue: String) { self.stringValue = stringValue }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
        
        static let lines = Key(stringValue: "lines")
        static let latitude = Key(stringValue: "latitude")
        static let longitude = Key(stringValue: "longitude")
    }
    
    var routes: [Route]
    var requestedLocation: Location
    
    init() {
        self.routes = Array()
        self.requestedLocation = Location(0.00, 1.012)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.requestedLocation = Location(
            try container.decode(Double.self, forKey: .latitude),
            try container.decode(Double.self, forKey: .longitude)
        )
        self.routes = try container.decode([Route].self, forKey: .lines)
//        self.routes = try container.nestedContainer(keyedBy: [Route.Key].self, forKey: Schedule.Key.lines)
//        routes = Array()
    }
}
