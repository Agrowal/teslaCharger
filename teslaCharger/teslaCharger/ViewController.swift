//
//  ViewController.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 18.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let client = TCPClient(address: "localhost", port: 8888)

    func establishConnection(){
        switch client.connect(timeout: 1) {
                case .success:
                switch client.send(string: "HELLO MOTO" ) {
                    case .success:
                        guard let data = client.read(1024*10) else { return }
        
                        if let response = String(bytes: data, encoding: .utf8) {
                            print(response)
                        }
                    case .failure(let error):
                        print(error)
                    }
            case .failure(let error):
            print(error)
        }
    }
    
    @IBAction func onButtonPressed(_ sender: Any) {
        establishConnection()
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

