//
//  ViewController.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 18.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let modbusTeslaCharger = fasadaModbus()
    
    @IBOutlet weak var chargerStatusLabel: UILabel!
    
    @IBAction func onButtonPressed(_ sender: Any) {
        //ON BUTTON
        modbusTeslaCharger.setChargingOnOff(OnOff: .ON)
    }
    
    @IBAction func offButtonPressed(_ sender: Any) {
        //OFF BUTTON
        modbusTeslaCharger.setChargingOnOff(OnOff: .OFF)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

