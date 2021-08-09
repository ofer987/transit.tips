//
//  Arrival.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class MyArrival {
    public var minutes: Int = 0
    public var seconds: Int = 0
    
    public init(_ minutes: Int, _ seconds: Int) {
        self.minutes = minutes
        self.seconds = seconds
    }
}
