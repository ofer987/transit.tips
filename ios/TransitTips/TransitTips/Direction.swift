//
//  Direction.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class Direction {
    public var arrivals: [Arrival] = [Arrival]()
    public var destinationStationName: String = ""
    
    public init(_ destinationStationName: String) {
        self.destinationStationName = destinationStationName
    }
}
