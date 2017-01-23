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
    
    private let transactionID :UInt16 = 1
    private let protocolID :UInt16 = 0
    private var length :UInt16 = 6              // DO PRZYSZLEJ ZMIANY - TO NIE JEST WARTOSC STALA
    private var slaveAddress :UInt8 = 1
    
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
    
    private var functionCode :UInt8 = 0
    private var startingAddress :UInt16 = 0
    private var pduData :[UInt8] = []
    
    var pduRequest :[UInt8] = []
    
    override init() {
        // some code
    }
    
    func setPDU(functionCode: Int, startingAddress: Int, pduData: [UInt8] ) {
        self.functionCode = UInt8(functionCode)
        self.startingAddress = UInt16(startingAddress)
        self.pduData = pduData
        makePduRequest()
    }
    
    func makePduRequest() {
        pduRequest.removeAll()
        pduRequest.append(functionCode)
        pduRequest.append(contentsOf: toByteArray(startingAddress, byteOrder: .BigEndian))
        pduRequest.append(contentsOf: pduData)
    }
    
    func getPduRequest() -> [UInt8] {
        return pduRequest
    }
    
}

class Modbus {
    
    let _byteTransformer = byteTransformer()
    let _MBAP = MBAP()
    let _PDU = PDU()
    
    let client = TCPClient(address: "127.0.0.1", port: 1502)
    
    enum functionCodes: Int {
        case ReadCoils=1
        case ReadDiscreteInputs=2
        case ReadHoldingRegisters=3
        case ReadInputRegisters=4
        
        case WriteSingleCoil=5
        case WriteSingleRegister=6
        case WriteMultipleCoils=15
        case WriteMultipleRegisters=16
        
        case ReadExceptionStatus_SerialLineOnly=7
        case Diagnostics_SerialLineOnly=8
        case GetCommEventCounter_SerialLineOnly=11
        case GetCommEventLog_SerialLineOnly=12
        case ReportSlaveID_SerialLineOnly=17
        
        case ReadFileRecord=20
        case WriteFileRecord=21
        
        case MaskWriteRegister=22
        case ReadWriteMultipleRegisters=23
        case ReadFIFOQueue=24
        case EncapsulatedInterfaceTransport=43
        case CANopenGeneralReferenceRequestandResponsePDU=13
        case ReadDeviceIdentification=14
    }
    
    enum coilValue :UInt16{
        case ONE = 65280 //0xFF00
        case ZERO = 0
    }
    

    var requestUInt :[UInt8] = []
    var requestData :Data = Data()
    
    init(){
    }
    
    
    func readData(functionCode: functionCodes, startingAddress: Int, quantityToRead: Int) {
        let readCodes = [1,2,3,4]
        if readCodes.contains(functionCode.rawValue){
            let quantityAsByteArray = _byteTransformer.toByteArray(UInt16(quantityToRead), byteOrder: .BigEndian)
            
             _PDU.setPDU(functionCode: functionCode.rawValue, startingAddress: startingAddress, pduData: quantityAsByteArray)
            prepareRequest()
            sendPreparedRequest()
            return
        }
        else{
            print("WRONG FUNCTION CODE")
            return
        }
    }
    
    func WriteSingleCoil(startingAddress: Int, coilValue: coilValue) {
        let coilValueAsByteArray = _byteTransformer.toByteArray(coilValue.rawValue, byteOrder: .BigEndian)
        
        _PDU.setPDU(functionCode: functionCodes.WriteSingleCoil.rawValue, startingAddress: startingAddress, pduData: coilValueAsByteArray)
        prepareRequest()
        sendPreparedRequest()
        return

    }
    
    func WriteSingleRegister(startingAddress: Int, registerValue: Int) {
        let registerValueAsByteArray = _byteTransformer.toByteArray(UInt16(registerValue), byteOrder: .BigEndian)
        
        _PDU.setPDU(functionCode: functionCodes.WriteSingleRegister.rawValue, startingAddress: startingAddress, pduData: registerValueAsByteArray)
        prepareRequest()
        sendPreparedRequest()
        return
        
    }
    
    
    func prepareRequest() {
        //CLEAN BYTE ARRAYS
        requestUInt.removeAll()
        requestData.removeAll()
        
        //FILL BYTE ARRAY
        requestUInt.append(contentsOf: _MBAP.getMbapRequest())
        requestUInt.append(contentsOf: _PDU.getPduRequest())
        
        //FILL DATA OBJECT
        requestData.append(contentsOf: requestUInt)
    }
    
    func sendPreparedRequest(){
        switch client.send(data: requestData) {
        case .success:
            guard let data = client.read(1024*10, timeout: 5) else { break}
            
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
    
    func establishConnection(){
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
    

    
    
}
