//
//  Stop.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

// TODO: add valdid functions
public class MyStationModel {
    public var name: String = ""
    public var location: MyLocation = MyLocation(latitude: 0.00, longitude: 0.00)
    public var directions = [MyDirection]()
    
    public init(_ name: String, _ location: MyLocation) {
        self.name = name
        self.location = location
    }
    
    public func distanceFrom(_ target: MyLocation) -> Double {
        return self.location - target
    }
}
