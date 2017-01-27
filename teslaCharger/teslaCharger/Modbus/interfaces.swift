//
//  interfaces.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 27.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class Singleton {
    
    // Singleton base class
    
    static let shared = Singleton()
    private init() {}
}
