//
//  Arrival.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class ArrivalModel {
    var minutes: Int
    var seconds: Int
    
    init(_ minutes: Int, _ seconds: Int) {
        self.minutes = minutes
        self.seconds = seconds
    }
}
