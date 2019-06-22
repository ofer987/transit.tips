//
//  Location.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class Location {
    var latitude: Double
    var longitude: Double
    // Maybe use inheritance instead: LocationWithAddress: Location
    var address: String?
    
    init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static prefix func -(_ other: Location) -> Double {
        return (pow(self.latitude - other.latitude, 2) + pow(self.longitude - other.longitude, 2)).squareRoot()
    }
}
