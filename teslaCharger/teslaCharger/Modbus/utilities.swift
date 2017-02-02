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
    
    func toByteArray<T>(_ value: T, byteOrder: ByteOrder) -> [UInt8] {
        var value = value
        let valueByteArray = withUnsafeBytes(of: &value) { Array($0)}
        return (byteOrder == .LittleEndian) ? valueByteArray : valueByteArray.reversed()
    }
    
    func fromByteArray<T>(_ value: [UInt8], _: T.Type, byteOrder: ByteOrder) -> T {
        let bytes = (byteOrder == .LittleEndian) ? value : value.reversed()
        return bytes.withUnsafeBytes {$0.baseAddress!.load(as: T.self)}
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

class ByteArray {
    var bytes :[UInt8] = []
    
    init(){
    }
    
    enum ByteCount {
        case One
        case Two
    }
    
    func append (value: Int, byteCount: ByteCount ) {
        if byteCount == .One {
            let convertedValue = Utilities.toByteArray(UInt8(value), byteOrder: .BigEndian)
            bytes.append(contentsOf: convertedValue)
        }
        else if byteCount == .Two {
            let convertedValue = Utilities.toByteArray(UInt16(value), byteOrder: .BigEndian)
            bytes.append(contentsOf: convertedValue)
        }
        else{
            print("ERROR")
        }
    }
    
    func append(value: [UInt8]) {
        bytes.append(contentsOf: value)
    }
    
    func removeAll() {
        bytes.removeAll()
    }
    
    
}
