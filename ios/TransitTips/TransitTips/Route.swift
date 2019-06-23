//
//  Route.swift
//  TransitTips
//
//  Created by Dan Jakob Ofer on 2019-06-22.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

class Route {
    var id: String
    var agencyId: String
    var title: String
    var directions: [Direction] = Array()
    
    init() {
        id = "1"
        agencyId = "2"
        title = "3"
        directions = Array()
    }
}
