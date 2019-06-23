//
//  Schedule.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class Schedule {
    var routes: [Route]
    var requestedLocation: Location
    
    init() {
        self.routes = Array()
        self.requestedLocation = Location(0.00, 1.012)
    }
}
