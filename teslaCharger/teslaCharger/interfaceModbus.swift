//
//  interfaceModbus.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 02.02.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation
import UIKit

class interfaceModbus {
    
    let client :TCPClient
    var chargerOn :Bool = false
    
    init() {
        client = TCPClient(address: "127.0.0.1", port: 1502)
        client.establishConnection()
    }
    
    func chargerToggle(BaterryStatus: UIImageView) {
        let offAction = WriteSingleCoilRequest(address: 4, value: !chargerOn, transaction_id: 1, protocol_id: 0, unit_id: 1, skip_encode: false)
        offAction.execute(client: client)
        
        chargerOn = !chargerOn
        
        if chargerOn {
            BaterryStatus.image = UIImage(named: "charge")
        }
        else {
            BaterryStatus.image = UIImage(named: "noCharge")
        }
    }

    
    
    
    
}
