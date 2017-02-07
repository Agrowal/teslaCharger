//
//  toByteArrayTransfomer.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 24.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class Utilities{
    
    init(){
    }
    
    enum ByteOrder {
        case BigEndian
        case LittleEndian
    }
    
    static func toByteArray<T>(_ value: T, byteOrder: ByteOrder) -> [UInt8] {
        var value = value
        let valueByteArray = withUnsafeBytes(of: &value) { Array($0)}
        return (byteOrder == .LittleEndian) ? valueByteArray : valueByteArray.reversed()
    }
    
    static func fromByteArray<T>(_ value: [UInt8], _: T.Type, byteOrder: ByteOrder) -> T {
        let bytes = (byteOrder == .LittleEndian) ? value : value.reversed()
        return bytes.withUnsafeBytes {$0.baseAddress!.load(as: T.self)}
    }
    
}


