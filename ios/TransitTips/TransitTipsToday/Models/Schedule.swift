//
//  Schedule.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class MySchedule {
    public var requestedAddress: MyLocation
    public var stations: [MyStation] = [MyStation]()
    
    public init(_ requestedAddress: MyLocation) {
        self.requestedAddress = requestedAddress
    }
}
