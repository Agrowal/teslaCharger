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
        (OnOff == .ON) ? modbus.WriteSingleCoil(startingAddress: 4, coilValue: .ONE) : modbus.WriteSingleCoil(startingAddress: 4, coilValue: .ZERO)
    }
    
        
    
}
