//
//  bit_write_message.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 28.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation


class WriteSingleCoilRequest: ModbusRequest {
    /*
    This function code is used to write a single output to either ON or OFF
    in a remote device.

    The requested ON/OFF state is specified by a constant in the request
    data field. A value of FF 00 hex requests the output to be ON. A value
    of 00 00 requests it to be OFF. All other values are illegal and will
    not affect the output.

    The Request PDU specifies the address of the coil to be forced. Coils
    are addressed starting at zero. Therefore coil numbered 1 is addressed
    as 0. The requested ON/OFF state is specified by a constant in the Coil
    Value field. A value of 0XFF00 requests the coil to be ON. A value of
    0X0000 requests the coil to be off. All other values are illegal and
    will not affect the coil.
    */
    let function_code = 5
    var address :Int
    var value :Bool

    init (address: Int = 0, value: Bool = false, unit_id: Int) {
        /* Initializes a new instance

        :param address: The variable address to write
        :param value: The value to write at address
        */
        self.address = address
        self.value = Bool(value)
        super.init(unit_id: unit_id)
        
        self._rtu_frame_size = 6

    }

    override func encode() {
        /* Encodes write coil request

        :returns: The byte encoded message
        */
        let modbusValue = (self.value) ? ModbusStatus.shared.On : ModbusStatus.shared.Off
        super.encode()

        //PDU
        frame.writeFrame(value: function_code,  byteCount: .One)
        frame.writeFrame(value: address,        byteCount: .Two)
        frame.writeFrame(value: modbusValue,    byteCount: .Two)
    }

    override func decode() {
        /* Decodes a write coil request

        :param data: The packet data to decode
        */
    }

    func execute(client: TCPClient) throws -> WriteSingleCoilResponse {
        /* Run a write coil request against a datastore

        :param context: The datastore to request from
        :returns: The populated response or exception message
        */
        
        encode()
        switch client.send(data: frame.getFrame()) {
        case .success:
            guard let readBuffer = client.read(1024*10, timeout: 5) else { break}
            print(readBuffer)
            return WriteSingleCoilResponse(buffer: readBuffer)
            
        case .failure(let error):
            throw ConnectionException()
        }
        abort()
    }
        
    func __str__() -> String  {
        /* Returns a string representation of the instance
        
        :return: A string representation of the instance
        */
        return "WriteCoilRequest(\(self.address),\(self.value)) => "
    }
}
class WriteSingleCoilResponse :ModbusResponse {
    /*
    The normal response is an echo of the request, returned after the coil
    state has been written.
    */
    var function_code = 5
    
    var address :Int?
    var value :Bool?

    init (transaction_id: Int, protocol_id: Int, unit_id: Int, address: Int = 0, value: Bool = false) {
        /* Initializes a new instance

        :param address: The variable address written to
        :param value: The value written at address
        */
        self.address = address
        self.value = value
        
        super.init(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id)
        
        self._rtu_frame_size = 6
    }
    
    init (buffer: [UInt8]) {
        /* Initlialize values from buffer
        */
        
        super.init()
        frame.setFrame(data: buffer)
        if hasErrorCode() {print("error"); abort()}
        decode()
        
    }
    
    override func encode() {
        /* Encodes write coil response

        :return: The byte encoded message
        */
        print("NOT IMPLEMENTED!!!")
    }
    
    override func decode() {
        /* Decodes a write coil response

        :param data: The packet data to decode
        */
        
        super.decode()
    
        let function_code    = frame.readFrame(begin: 7, end: 7)
        if (function_code   != self.function_code){print("ERROR");return}
        
        self.address         = frame.readFrame(begin: 8, end: 9)
        let valueAsInt       = frame.readFrame(begin: 10, end: 11)
        
        value = (valueAsInt == ModbusStatus.shared.On) ? true : false
    }
    
    func __str__() -> String {
        /* Returns a string representation of the instance

        :returns: A string representation of the instance
        */
        return "WriteCoilResponse \(self.address) => \(self.value)"
    }

}

