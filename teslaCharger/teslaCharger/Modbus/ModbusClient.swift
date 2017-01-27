//
//  Modbus.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 21.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class ModbusClient: Utilities {
    
    var ModbusStatus1 = ModbusStatus.shared
    
    
    let _MBAP = ModbusMbap()
    let _PDU = ModbusPdu()
    
    let client :TCPClient
    
    var requestUInt :[UInt8] = []
    var requestData :Data = Data()
    
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
    
    init(address: String, port: Int32){
        client = TCPClient(address: address, port: port)
    }
    
    
    func readData(functionCode: functionCodes, startingAddress: Int, quantityToRead: Int) {
        let readCodes = [1,2,3,4]
        if readCodes.contains(functionCode.rawValue){
            let quantityAsByteArray = toByteArray(UInt16(quantityToRead), byteOrder: .BigEndian)
            
             _PDU.setPDU(functionCode: functionCode.rawValue, startingAddress: startingAddress, pduData: quantityAsByteArray)
            
            sendPreparedRequest(request: preparedRequest())
            return
        }
        else{
            print("WRONG FUNCTION CODE")
            return
        }
    }
    
    func WriteSingleCoil(startingAddress: Int, coilValue: coilValue) {
        let coilValueAsByteArray = toByteArray(coilValue.rawValue, byteOrder: .BigEndian)
        
        _PDU.setPDU(functionCode: functionCodes.WriteSingleCoil.rawValue, startingAddress: startingAddress, pduData: coilValueAsByteArray)

        sendPreparedRequest(request: preparedRequest())
        return

    }
    
    func WriteSingleRegister(startingAddress: Int, registerValue: Int) {
        let registerValueAsByteArray = toByteArray(UInt16(registerValue), byteOrder: .BigEndian)
        
        _PDU.setPDU(functionCode: functionCodes.WriteSingleRegister.rawValue, startingAddress: startingAddress, pduData: registerValueAsByteArray)

        sendPreparedRequest(request: preparedRequest())
        return
        
    }
    
    func WriteMultipleRegisters(startingAddress: Int, registerValues: [Int]) {
        
        let quantityOfRegisters = UInt16(registerValues.count)
        let quantityAsByteArray = toByteArray(quantityOfRegisters, byteOrder: .BigEndian)
        
        let byteCount = [UInt8(quantityOfRegisters*2)]
        
        var registerValuesAsByteArray:[UInt8] = []
        for value in registerValues {
            registerValuesAsByteArray.append(contentsOf: toByteArray(UInt16(value), byteOrder: .BigEndian))
        }
        
        let pduData = quantityAsByteArray + byteCount + registerValuesAsByteArray
        
        _PDU.setPDU(functionCode: functionCodes.WriteMultipleRegisters.rawValue, startingAddress: startingAddress, pduData: pduData)

        sendPreparedRequest(request: preparedRequest())
        return
        
    }
    
    
    
    func preparedRequest() -> Data{
        //INITIALIZE EMPTY ARRAYS
        var requestUInt :[UInt8] = []
        var requestData :Data = Data()
        
        //FILL BYTE ARRAY
        let mbapLengthValue = _PDU.getPduRequest().count + 1
        _MBAP.setLength(newLength: mbapLengthValue)
        requestUInt.append(contentsOf: _MBAP.getMbapRequest())
        
        requestUInt.append(contentsOf: _PDU.getPduRequest())
        print("SENDING: \(requestUInt)")
        
        
        //FILL DATA OBJECT
        requestData.append(contentsOf: requestUInt)
        return requestData
    }
    
    func sendPreparedRequest(request: Data){
        switch client.send(data: request) {
        case .success:
            guard let data = client.read(1024*10, timeout: 5) else { break}
            
            let mbapLength = _MBAP.getMbapRequest().count
            let mbapResponse = data[0..<mbapLength]
            let pduResponse = data.dropFirst(mbapLength)
            
            print("RESPONSE DATA:")
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
