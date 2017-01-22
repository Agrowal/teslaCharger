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
    var length :UInt16 = 6
    var slaveAddress :UInt8 = 1
    
    var byteMBAPHeader :[UInt8] = []
    
    override init() {
        super.init()
        makeMBAPRequest()
    }
    
    func makeMBAPRequest() {
        let MBAPHeaderItems :[UInt16]  = [transactionID,protocolID,length]
        
        for item in MBAPHeaderItems{
            byteMBAPHeader.append(contentsOf: toByteArray(item, byteOrder: .BigEndian))
        }
        
        byteMBAPHeader.append(slaveAddress)
    }
    
    func getMBAP()-> [UInt8] {
        return byteMBAPHeader
    }
    
    func getMBAPData() -> Data {
        return Data(bytes: byteMBAPHeader)
    }
    
}

class PDU : byteTransformer {
    
    var functionCode :UInt8
    var startingAddress :UInt16
    var quantityOfRegisters :UInt16
    
    var bytePDURequest :[UInt8] = []
    
    init(functionCode: Int, startingAddress: Int, quantityOfRegisters: Int ){
        self.functionCode = UInt8(functionCode)
        self.startingAddress = UInt16(startingAddress)
        self.quantityOfRegisters = UInt16(quantityOfRegisters)
        super.init()
        makePDURequest()
        
    }
    
    func makePDURequest() {
        bytePDURequest.append(functionCode)
        bytePDURequest.append(contentsOf: toByteArray(startingAddress, byteOrder: .BigEndian))
        bytePDURequest.append(contentsOf: toByteArray(quantityOfRegisters, byteOrder: .BigEndian))
    }
    
    func getPDU() -> [UInt8] {
        return bytePDURequest
    }
    
    func getPDUData() -> Data {
        return Data(bytes: bytePDURequest)
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
        _PDU = PDU(functionCode: 3, startingAddress: 2, quantityOfRegisters: 6)
        makeRequestUint()
        makeRequestData()
        print("BUILD SUCCESSFUL")
    }
    
    func makeRequestUint() {
        requestUInt.append(contentsOf: _MBAP.getMBAP())
        requestUInt.append(contentsOf: _PDU.getPDU())
    }

    func makeRequestData() {
        requestData.append(_MBAP.getMBAPData())
        requestData.append(_PDU.getPDUData())
    }
    
    func getRequest() -> Data {
        return requestData
    }
    
    func establishConnection(){
        switch client.connect(timeout: 1) {
        case .success:
          //  guard let data = client.read(1024*10) else { return }
            
          //  if let response = String(bytes: data, encoding: .utf8) {
           //     print(response)
           // }
            print("SUCCESS")
            
        case .failure(let error):
            print(error)
        }
    }
    
    func sendDataAndRecieveAnwser(inpuData: Data){
        switch client.send(data: inpuData) {
        case .success:
            guard let data = client.read(1024*10) else { break}
            
            print(data)
            
        case .failure(let error):
            print(error)
        }
    }
    
    
}
