//
//  Stop.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

// TODO: add valdid functions
class StationModel {
    var name: String = ""
    var location: LocationModel = LocationModel(0.00, 0.00)
    var directions = [DirectionModel]()
    
    init(_ name: String, _ location: LocationModel) {
        self.location = location
    }

    func distanceFrom(_ target: LocationModel) -> Double {
        return self.location - target
    }
}
