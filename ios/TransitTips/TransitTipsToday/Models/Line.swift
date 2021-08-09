//
//  Line.swift
//  Common.Models
//
//  Created by Dan Jakob Ofer on 2019-07-10.
//  Copyright © 2019 Dan Jakob Ofer. All rights reserved.
//

import Foundation

public class MyLine {
    public var directions: [MyDirection] = [MyDirection]()
    public var id: Int = 0
    public var name: String = ""
    
    public init(_ id: Int, _ name: String) {
        self.id = id
        self.name = name
    }
    
    public func isValid() -> Bool {
        return true
    }
}
