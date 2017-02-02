//
//  ViewController.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 18.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //let client = TCPClient(address: "127.0.0.1", port: 1502)
    //var chargerStatus = "ON"
    let interface = interfaceModbus()
    
    @IBOutlet weak var BatteryStatus: UIImageView!
    
    @IBAction func onOffButtonPressed(_ sender: Any) {
        interface.chargerToggle(BaterryStatus: BatteryStatus)
        /*
        if chargerStatus == "ON" {
            let offAction = WriteSingleCoilRequest(address: 4, value: false, transaction_id: 1, protocol_id: 0, unit_id: 1, skip_encode: false)
            offAction.execute(client: client)
            chargerStatus = "OFF"
            BatteryStatus.image = UIImage(named: "noCharge")
        }
        else {
            let onAction = WriteSingleCoilRequest(address: 4, value: true, transaction_id: 1, protocol_id: 0, unit_id: 1, skip_encode: false)
            onAction.execute(client: client)
            chargerStatus = "ON"
            BatteryStatus.image = UIImage(named: "charge")
        }
         */
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarStyle = .lightContent
        
        //client.establishConnection()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    

}

