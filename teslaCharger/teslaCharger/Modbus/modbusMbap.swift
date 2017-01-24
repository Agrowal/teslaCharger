//
//  modbusMbap.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 24.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class ModbusMbap : Utilities {
    
    private let transactionID :UInt16 = 1
    private let protocolID :UInt16 = 0
    private var length :UInt16 = 6
    private var slaveAddress :UInt8 = 1
    
    var mbpaRequest :[UInt8] = []
    
    override init(){
        
    }
    
    
    func makeMbapRequest() {
        mbpaRequest.removeAll()
        mbpaRequest.append(contentsOf: toByteArray(transactionID, byteOrder: .BigEndian))
        mbpaRequest.append(contentsOf: toByteArray(protocolID, byteOrder: .BigEndian))
        mbpaRequest.append(contentsOf: toByteArray(length, byteOrder: .BigEndian))
        mbpaRequest.append(slaveAddress)
    }
    
    func setSlaveAddress(newSlaveAddress: Int) {
        slaveAddress = UInt8(newSlaveAddress)
        makeMbapRequest()
    }
    
    func getSlaveAddress() -> UInt8 {
        return slaveAddress
    }
    
    func setLength(newLength: Int) {
        length = UInt16(newLength)
        makeMbapRequest()
    }
    
    func getMbapRequest()-> [UInt8] {
        return mbpaRequest
    }
    
}
