//
//  fasadaModbus.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 22.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class fasadaModbus : Modbus{
    
    override init(){
        super.init()
        super.establishConnection()
    }
    
    func setChargingON() {
        super.prepareRequest(functionCode: 5, startingAddress: 4, quantityOfRegisters: 65280)
        super.sendPreparedRequest()
    }
    
}
