//
//  modbusPdu.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 24.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class ModbusPdu : Utilities {
    
    private var functionCode :UInt8 = 0
    private var startingAddress :UInt16 = 0
    private var pduData :[UInt8] = []
    
    var pduRequest :[UInt8] = []
    
    override init() {
        // some code
    }
    
    func setPDU(functionCode: Int, startingAddress: Int, pduData: [UInt8] ) {
        self.functionCode = UInt8(functionCode)
        self.startingAddress = UInt16(startingAddress)
        self.pduData = pduData
        makePduRequest()
    }
    
    func makePduRequest() {
        pduRequest.removeAll()
        pduRequest.append(functionCode)
        pduRequest.append(contentsOf: toByteArray(startingAddress, byteOrder: .BigEndian))
        pduRequest.append(contentsOf: pduData)
    }
    
    func getPduRequest() -> [UInt8] {
        return pduRequest
    }
    
}
