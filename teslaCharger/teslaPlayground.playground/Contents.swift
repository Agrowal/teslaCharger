//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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


class MBAPHeader: byteTransformer {
    
    let transactionID :UInt16 = 1
    let protocolID :UInt16 = 0
    var length :UInt16 = 3
    var slaveAddress :UInt8 = 1
    
    var byteMBAPHeader :[UInt8] = []
    
    override init() {
        super.init()
        makeMBAP()
    }
    
    func makeMBAP() {
        let MBAPHeaderItems :[UInt16]  = [transactionID,protocolID,length]
        
        for item in MBAPHeaderItems{
            byteMBAPHeader.append(contentsOf: toByteArray(item, byteOrder: .BigEndian))
        }
        
        byteMBAPHeader.append(slaveAddress)
        print(byteMBAPHeader)
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
        
    }
    
    func makePDURequest() {
        bytePDURequest.append(functionCode)
        bytePDURequest.append(contentsOf: toByteArray(startingAddress, byteOrder: .BigEndian))
        bytePDURequest.append(contentsOf: toByteArray(quantityOfRegisters, byteOrder: .BigEndian))
    }
    
}

let mbap = MBAPHeader()

let mpdu = PDU(functionCode: 1, startingAddress: 0, quantityOfRegisters: 3)
mpdu.makePDURequest()