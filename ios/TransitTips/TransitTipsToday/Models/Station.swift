//
//  Station.swift
//  Common.Models
//
//  Created by Dan Jakob Ofer on 2019-07-10.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class MyStation {
    public var lines: [MyLine] = [MyLine]()
    public var id: Int = 0
    public var name: String = ""
    public var address: MyLocation
    
    public init(_ id: Int, _ name: String, _ address: MyLocation) {
        self.id = id
        self.name = name
        self.address = address
    }
    
    public func isValid() -> Bool {
        return true
    }
}
