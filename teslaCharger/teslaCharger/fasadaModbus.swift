//
//  fasadaModbus.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 22.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class fasadaModbus {
    
    let modbus :Modbus
    
    let coilZero = Int(0x0000)
    let coilOne = Int(0xFF00)
    
    enum OnOff {
        case ON
        case OFF
    }
    
    init(){
        modbus = Modbus()
        modbus.establishConnection()
    }
    
   
    func setChargingOnOff(OnOff: OnOff) {
        let state = (OnOff == .ON) ? coilOne : coilZero
        modbus.prepareRequest(functionCode: 5, startingAddress: 4, quantityOfRegisters: state)
        modbus.sendPreparedRequest()
    }

    
    
}
