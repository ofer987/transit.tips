//
//  Direction.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class DirectionModel {
    // TODO: why can id be null?
    var id: String? = ""
    var title: String = ""
    var shortTitle: String = ""
    var destinationStationName: String = ""
    var arrivals: [ArrivalModel] = [ArrivalModel]()
}
