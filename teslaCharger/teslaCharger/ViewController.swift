//
//  ViewController.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 18.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //let modbusTeslaCharger = fasadaModbus()
    
    @IBOutlet weak var chargerStatusLabel: UILabel!
    
    @IBAction func onButtonPressed(_ sender: Any) {
        //ON BUTTON
        //modbusTeslaCharger.setChargingOnOff(OnOff: .ON)
    }
    
    @IBAction func offButtonPressed(_ sender: Any) {
        //OFF BUTTON
       //modbusTeslaCharger.setChargingOnOff(OnOff: .OFF)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let client = TCPClient(address: "192.168.8.3", port: 1502)
        switch client.connect(timeout: 1) {
        case .success:
            guard let data = client.read(1024*10, timeout: 1) else { return }
            
            if let serverResponse = String(bytes: data, encoding: .utf8) {
                print(serverResponse)
            }
            
        case .failure(let error):
            print(error)
        }
        let foo = WriteSingleCoilRequest(address: 1, value: true, transaction_id: 1, protocol_id: 0, unit_id: 0, skip_encode: false)
        foo.execute(client: client)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    

}

