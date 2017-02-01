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
    let client = TCPClient(address: "192.168.8.3", port: 1502)
    var chargerStatus = "ON"
    
    @IBAction func onOffButtonPressed(_ sender: Any) {
        if chargerStatus == "ON" {
            let offAction = WriteSingleCoilRequest(address: 4, value: false, transaction_id: 1, protocol_id: 0, unit_id: 1, skip_encode: false)
            offAction.execute(client: client)
            chargerStatus = "OFF"
        }
        else {
            let onAction = WriteSingleCoilRequest(address: 4, value: true, transaction_id: 1, protocol_id: 0, unit_id: 1, skip_encode: false)
            onAction.execute(client: client)
            chargerStatus = "ON"
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        switch client.connect(timeout: 1) {
        case .success:
            guard let data = client.read(1024*10, timeout: 1) else { return }
            
            if let serverResponse = String(bytes: data, encoding: .utf8) {
                print(serverResponse)
            }
            
        case .failure(let error):
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    

}

