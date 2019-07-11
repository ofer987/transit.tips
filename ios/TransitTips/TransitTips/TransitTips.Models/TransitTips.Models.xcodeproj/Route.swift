//
//  Route.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class Route : Decodable {
    struct Key : CodingKey {
        var stringValue: String
        init(stringValue: String) { self.stringValue = stringValue }
        
        var intValue: Int?
        init?(intValue: Int) { return nil }
        
        static let id = Key(stringValue: "id")
        static let name = Key(stringValue: "name")
//        static let stations = Key(stringValue: "stations")
    }
    
    var id: String
    var agencyId: String
    var title: String
    var directions: [Direction] = Array()
    
    init() {
        id = "1"
        agencyId = "2"
        title = "3"
        directions = Array()
    }
    
    required public init(from decoder: Decoder) throws {
        id = "1"
        agencyId = "2"
        title = "3"
        directions = Array()
    }
}
