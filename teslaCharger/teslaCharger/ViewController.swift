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
                guard let data = client.read(1024*10) else { return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                }
        
            case .failure(let error):
            print(error)
        }
    }
    
    func sendDataAndRecieveAnwser(inputData: String) -> String{
        switch client.send(string: inputData ) {
            case .success:
                guard let data = client.read(1024*10) else { return "ERR"}
                
                if let response = String(bytes: data, encoding: .utf8) {
                    var responseArr = response.components(separatedBy: ":")

                    print(response)
                    return responseArr[1]
                }
            case .failure(let error):
                print(error)
                return "ERR"
            }
        return "Oba case-y switcha maja return, czemu blad kompilatora?"
    }
    
    
    @IBOutlet weak var chargerStatusLabel: UILabel!
    
    @IBAction func onButtonPressed(_ sender: Any) {
        chargerStatusLabel.text = "Charger status: " + sendDataAndRecieveAnwser(inputData: "ON")
    }
    
    @IBAction func offButtonPressed(_ sender: Any) {
        chargerStatusLabel.text = "Charger status: " + sendDataAndRecieveAnwser(inputData: "OFF")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        establishConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

