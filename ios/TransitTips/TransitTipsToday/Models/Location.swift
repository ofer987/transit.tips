//
//  Location.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class MyLocation {
    public var latitude: Double
    public var longitude: Double
    // Maybe use inheritance instead: LocationWithAddress: Location
    public var address: String?
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public static func -(_ source: MyLocation, _ target: MyLocation) -> Double {
        return (pow(source.latitude - target.latitude, 2) + pow(source.longitude - target.longitude, 2)).squareRoot()
    }
}
