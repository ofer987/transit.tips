//
//  Location.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class LocationModel {
    var latitude: Double
    var longitude: Double
    // Maybe use inheritance instead: LocationWithAddress: Location
    var address: String?
    
    init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func -(_ source: LocationModel, _ target: LocationModel) -> Double {
        return (pow(source.latitude - target.latitude, 2) + pow(source.longitude - target.longitude, 2)).squareRoot()
    }
}
