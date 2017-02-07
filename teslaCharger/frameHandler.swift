//
//  frameHandler.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 07.02.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

class frameHandler {
    var frame :[UInt8]
    
    init(data: [UInt8] = []){
        self.frame = data
    }
    
    enum ByteCount {
        case One
        case Two
    }
    
    func writeFrame (value: Int, byteCount: ByteCount ) {
        if byteCount == .One {
            let convertedValue = Utilities.toByteArray(UInt8(value), byteOrder: .BigEndian)
            frame.append(contentsOf: convertedValue)
        }
        else if byteCount == .Two {
            let convertedValue = Utilities.toByteArray(UInt16(value), byteOrder: .BigEndian)
            frame.append(contentsOf: convertedValue)
        }
        else{
            print("ERROR")
        }
    }
    
    func readFrame(begin: Int, end: Int) -> Int {
        let arraySlice = Array(frame[begin...end])
        let byteCount = arraySlice.count
        switch byteCount {
        case 1:
            // One byte
            return Int(Utilities.fromByteArray(arraySlice, UInt8.self, byteOrder: .BigEndian))
        case 2:
            // Two byte
            return Int(Utilities.fromByteArray(arraySlice, UInt16.self, byteOrder: .BigEndian))
        case 4:
            //Four bytes
            return Int(Utilities.fromByteArray(arraySlice, UInt32.self, byteOrder: .BigEndian))
        default:
            return Int(Utilities.fromByteArray(arraySlice, UInt8.self, byteOrder: .BigEndian))
        }
        
    }
    
    ///// Do I need it ???
    func append(value: [UInt8]) {
        frame.append(contentsOf: value)
    }
    /////
    
    func resetFrame() {
        frame.removeAll()
    }
    
    func setFrame(data: [UInt8]) {
        self.frame = data
    }
    
    func getFrame() -> [UInt8] {
        return frame
    }
    
}
