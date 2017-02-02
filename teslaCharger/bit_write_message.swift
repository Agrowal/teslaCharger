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
    let _rtu_frame_size = 6
    
    var address :Int
    var value :Bool
    
    var byteArray = ByteArray()

    init (address: Int = 0, value: Bool = false, transaction_id: Int, protocol_id: Int, unit_id: Int, skip_encode :Bool) {
        /* Initializes a new instance

        :param address: The variable address to write
        :param value: The value to write at address
        */
        self.address = address
        self.value = Bool(value)
        super.init(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id, skip_encode: skip_encode)

    }

    override func encode() {
        /* Encodes write coil request

        :returns: The byte encoded message
        */
        
       
        let modbusValue = ByteArray()
        
        if self.value {
            modbusValue.append(value: ModbusStatus.shared.On, byteCount: .Two)
        }
        else {
            modbusValue.append(value: ModbusStatus.shared.Off, byteCount: .Two)
        }

        
        byteArray.removeAll()
        
        //MBAP
        byteArray.append(value: transaction_id, byteCount: .Two)
        byteArray.append(value: protocol_id,    byteCount: .Two)
        byteArray.append(value: _rtu_frame_size,byteCount: .Two)
        byteArray.append(value: unit_id,        byteCount: .One)

        //PDU
        byteArray.append(value: function_code,  byteCount: .One)
        byteArray.append(value: address,        byteCount: .Two)
        byteArray.append(value: modbusValue.bytes)
        
    }

    override func decode(data: Data) {
        /* Decodes a write coil request

        :param data: The packet data to decode
        */
        
        let codedValue = Array(byteArray.bytes.dropLast(2))
        let codedAddress = Array(byteArray.bytes.dropLast(2))
        
        //Utilities.fromByteArray(codedValue, UInt16, byteOrder: .LittleEndian)
        
    }

    func execute(client: TCPClient) {
        /* Run a write coil request against a datastore

        :param context: The datastore to request from
        :returns: The populated response or exception message
        */
        
        //if self.value not in [ModbusStatus.Off, ModbusStatus.On]:
            //    return self.doException(merror.IllegalValue)
        
        /* !!!!!TO DO!!!!!!      !!!!!TO DO!!!!!!      !!!!!TO DO!!!!!!
        if not context.validate(self.function_code, self.address, 1):
        return self.doException(merror.IllegalAddress)
            
        context.setValues(self.function_code, self.address, [self.value])
        values = context.getValues(self.function_code, self.address, 1)
        return WriteSingleCoilResponse(self.address, values[0])
         */
        
        encode()
        //let dataa :Data = Data(bytes: byteArray)
        
        switch client.send(data: byteArray.bytes) {
        case .success:
            guard let data = client.read(1024*10, timeout: 5) else { break}
        case .failure(let error):
            print(error)
        }
        
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
    let function_code = 5
    let _rtu_frame_size = 8
    
    var address :Int
    var value :Bool

    init (address: Int = 0, value: Bool = false, transaction_id: Int, protocol_id: Int, unit_id: Int, skip_encode :Bool) {
        /* Initializes a new instance

        :param address: The variable address written to
        :param value: The value written at address
        */
        self.address = address
        self.value = value
        
        super.init(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id, skip_encode: skip_encode)
        

    }
    
    override func encode() {
        /* Encodes write coil response

        :return: The byte encoded message
        */
        
        //result  = struct.pack('>H', self.address)
        //if self.value: result += _turn_coil_on
        //else: result += _turn_coil_off
        //return result
    }
    
    override func decode(data: Data) {
        /* Decodes a write coil response

        :param data: The packet data to decode
        */
        
        //self.address, value = struct.unpack('>HH', data)
        //self.value = (value == ModbusStatus.On)
    }
    
    func __str__() -> String {
        /* Returns a string representation of the instance

        :returns: A string representation of the instance
        */
        return "WriteCoilResponse \(self.address) => \(self.value)"
    }
}
