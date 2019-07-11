//
//  Schedule.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class Schedule {
    public var requestedAddress: Location
    public var stations: [Station] = [Station]()
    
    public init(_ requestedAddress: Location) {
        self.requestedAddress = requestedAddress
    }
}
