//
//  Schedule.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class ScheduleModel {
    var routes: [RouteModel] = [RouteModel]()
    var requestedLocation: LocationModel = LocationModel(0.00, 0.00)
}
