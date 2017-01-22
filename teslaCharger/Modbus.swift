//
//  Modbus.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 21.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class byteTransformer{
    
    init(){
    }
    
    enum ByteOrder {
        case BigEndian
        case LittleEndian
    }
    
    func toByteArray<T>(_ value: T, byteOrder: ByteOrder) -> [UInt8] {
        var value = value
        let valueByteArray = withUnsafeBytes(of: &value) { Array($0)}
        return (byteOrder == .LittleEndian) ? valueByteArray : valueByteArray.reversed()
    }
    
    func fromByteArray<T>(_ value: [UInt8], _: T.Type, byteOrder: ByteOrder) -> T {
        let bytes = (byteOrder == .LittleEndian) ? value : value.reversed()
        return bytes.withUnsafeBytes {$0.baseAddress!.load(as: T.self)}
    }
}


class MBAP : byteTransformer {
    
    let transactionID :UInt16 = 1
    let protocolID :UInt16 = 0
    var length :UInt16 = 6              // DO PRZYSZLEJ ZMIANY - TO NIE JEST WARTOSC STALA
    var slaveAddress :UInt8 = 1
    
    var mbpaRequest :[UInt8] = []
    
    override init() {
        super.init()
        makeMbapRequest()
    }
    
    func makeMbapRequest() {
        mbpaRequest.removeAll()
        mbpaRequest.append(contentsOf: toByteArray(transactionID, byteOrder: .BigEndian))
        mbpaRequest.append(contentsOf: toByteArray(protocolID, byteOrder: .BigEndian))
        mbpaRequest.append(contentsOf: toByteArray(length, byteOrder: .BigEndian))
        mbpaRequest.append(slaveAddress)
    }
    
    func setSlaveAddress(newSlaveAddress: Int) {
        slaveAddress = UInt8(newSlaveAddress)
        makeMbapRequest()
    }
    
    func getSlaveAddress() -> UInt8 {
        return slaveAddress
    }
    
    func getMbapRequest()-> [UInt8] {
        return mbpaRequest
    }
    
}

class PDU : byteTransformer {
    
    var functionCode :UInt8 = 0
    var startingAddress :UInt16 = 0
    var quantityOfRegisters :UInt16 = 0
    
    var coilInputsArr :[UInt8] = []
    var holdingInputsArr :[UInt16] = []
    
    var pduRequest :[UInt8] = []
    
    override init() {
        // some code
    }
    
    func setPDU(functionCode: Int, startingAddress: Int, quantityOfRegisters: Int ) {
        self.functionCode = UInt8(functionCode)
        self.startingAddress = UInt16(startingAddress)
        self.quantityOfRegisters = UInt16(quantityOfRegisters)
        makePduRequest()
    }
    
    func makePduRequest() {
        pduRequest.removeAll()
        pduRequest.append(functionCode)
        pduRequest.append(contentsOf: toByteArray(startingAddress, byteOrder: .BigEndian))
        pduRequest.append(contentsOf: toByteArray(quantityOfRegisters, byteOrder: .BigEndian))
    }
    
    func getPduRequest() -> [UInt8] {
        return pduRequest
    }
    
}

class Modbus {
    
    let client = TCPClient(address: "192.168.8.3", port: 1502)
    
    var _MBAP :MBAP
    var _PDU :PDU
    var requestUInt :[UInt8] = []
    var requestData :Data = Data()
    
    init(){
        _MBAP = MBAP()
        _PDU = PDU()
        print("BUILD SUCCESSFUL")
    }
    
    func prepareRequest(functionCode: Int, startingAddress: Int, quantityOfRegisters: Int) {

        _PDU.setPDU(functionCode: functionCode, startingAddress: startingAddress, quantityOfRegisters: quantityOfRegisters)
        
        //FILL BYTE ARRAY
        requestUInt.append(contentsOf: _MBAP.getMbapRequest())
        requestUInt.append(contentsOf: _PDU.getPduRequest())
        
        //FILL DATA OBJECT
        requestData.append(contentsOf: requestUInt)
    }
    
    func getRequest() -> Data {
        return requestData
    }
    
    func establishConnection(){
        switch client.connect(timeout: 1) {
        case .success:
            guard let data = client.read(1024*10, timeout: 1) else { return }
            
            if let response = String(bytes: data, encoding: .utf8) {
                print(response)
            }
            
        case .failure(let error):
            print(error)
        }
    }
    
    func sendPreparedRequest(){
        switch client.send(data: requestData) {
        case .success:
            guard let data = client.read(1024*10) else { break}
            
            print("DATA: \(data)")
            
            let mbapLength = _MBAP.getMbapRequest().count
            let mbapResponse = data[0..<mbapLength]
            
            let pduResponse = data.dropFirst(mbapLength)

            
            print("MBAP respones: \(mbapResponse)")
            print("PDU respones: \(pduResponse) ")
            
        case .failure(let error):
            print(error)
        }
    }
    
    
}
