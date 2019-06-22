//
//  Stop.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class Stop {
    var location: Location
    
    init(_ location: Location) {
        self.location = location
    }

    func distanceFrom(_ other: Location) -> Double {
        return self.location - other
    }
}
