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
    
    func sendStringAndRecieveAnwser(inputData: String) -> String{
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
    
    
    
    func sendDataAndRecieveAnwser(inpuData: Data, action: String){
        switch client.send(data: inpuData) {
            case .success:
                guard let data = client.read(1024*10) else { break}
                
                let funcNumber = data[0]
                let addressArr = Data(data[1...2])
                let address = UInt16(bigEndian: addressArr.withUnsafeBytes {$0.pointee})
                let valueArr = Data(data[3...4])
                let value = UInt16(bigEndian: valueArr.withUnsafeBytes {$0.pointee})
                
                switch action{
                    case "ON":
                        chargerStatusLabel.text = "Charger status: ONLINE"
                    case "OFF":
                        chargerStatusLabel.text = "Charger status: OFFLINE"
                    default:
                        chargerStatusLabel.text = "Charger status: ERROR"
                }
                
                print(data)
                print("Funkcja: \(funcNumber), Adres: \(address), Wartość: \(value)")
                
            case .failure(let error):
                print(error)
            }
    }
    
    
    @IBOutlet weak var chargerStatusLabel: UILabel!
    
    @IBAction func onButtonPressed(_ sender: Any) {
        let request :[UInt8] = [0x05,0x01,0x90,0xFF,0x00]
        let requestData = Data(request)
        
        sendDataAndRecieveAnwser(inpuData: requestData, action: "ON")
        
    }
    
    @IBAction func offButtonPressed(_ sender: Any) {
        let request :[UInt8] = [0x05,0x01,0x90,0x00,0x00]
        let requestData = Data(request)
        
        sendDataAndRecieveAnwser(inpuData: requestData, action: "OFF")
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

