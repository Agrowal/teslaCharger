//
//  pdu.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 27.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

/*

Contains base classes for modbus request/response/error packets


from pymodbus.exceptions import NotImplementedException
from pymodbus.utilities import rtuFrameSize

#---------------------------------------------------------------------------#
# Logging
#---------------------------------------------------------------------------#
import logging
_logger = logging.getLogger(__name__)
*/

//---------------------------------------------------------------------------//
//Base PDU's
//---------------------------------------------------------------------------//
class ModbusPDU {
    /*
    Base class for all Modbus mesages

    .. attribute:: transaction_id

    This value is used to uniquely identify a request
    response pair.  It can be implemented as a simple counter

    .. attribute:: protocol_id

    This is a constant set at 0 to indicate Modbus.  It is
    put here for ease of expansion.

    .. attribute:: unit_id

    This is used to route the request to the correct child. In
    the TCP modbus, it is used for routing (or not used at all. However,
    for the serial versions, it is used to specify which child to perform
    the requests against. The value 0x00 represents the broadcast address
    (also 0xff).
    
    .. attribute:: check
    
    This is used for LRC/CRC in the serial modbus protocols
    
    .. attribute:: skip_encode
    
    This is used when the message payload has already been encoded.
    Generally this will occur when the PayloadBuilder is being used
    to create a complicated message. By setting this to True, the
    request will pass the currently encoded message through instead
    of encoding it again.
    */
    
    let transaction_id  :Int
    let protocol_id     :Int
    let unit_id         :Int
    let skip_encode     :Bool
    let check           :UInt16
    
    init(transaction_id: Int, protocol_id: Int, unit_id: Int, skip_encode :Bool){
        // Initializes the base data for a modbus request //
        self.transaction_id = transaction_id
        self.protocol_id = protocol_id
        self.unit_id = unit_id
        self.skip_encode = skip_encode
        self.check = 0x0000
    }
    
    func encode(){
        /* Encodes the message
        
        :raises: A not implemented exception
        */
        
        print("not implemented")
        //raise NotImplementedException()
    }
        
    func decode(data: Data){
        /* Decodes data part of the message.
        
        :param data: is a string object
        :raises: A not implemented exception
        */
        
        print("not implemented")
        //raise NotImplementedException()
    }

    static func calculateRtuFrameSize(buffer: Data){
        /* Calculates the size of a PDU.

        :param buffer: A buffer containing the data that have been received.
        :returns: The number of bytes in the PDU.
         
 
        if hasattr(cls, '_rtu_frame_size'){
            return cls._rtu_frame_size
        }
        elif hasattr(cls, '_rtu_byte_count_pos'){
            return rtuFrameSize(buffer, cls._rtu_byte_count_pos)
        }
        else {
            raise NotImplementedException("Cannot determine RTU frame size for %s" % cls.__name__)
        }*/
        return
    }
}

class ModbusRequest: ModbusPDU {
    // Base class for a modbus request PDU //

    override init(transaction_id: Int, protocol_id: Int, unit_id: Int, skip_encode :Bool){
        // Proxy to the lower level initializer //
        
        super.init(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id, skip_encode: skip_encode)
        //ModbusPDU(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id, skip_encode: skip_encode)
    }

    func doException(exception: String){
        /* Builds an error response based on the function

        :param exception: The exception to return
        :raises: An exception response
        */
        //_logger.error("Exception Response F\(self.function_code) E\(exception)")
        //return ExceptionResponse(self.function_code, exception)
        print(exception)
    }
}

class ModbusResponse: ModbusPDU {
    /* Base class for a modbus response PDU

    .. attribute:: should_respond

    A flag that indicates if this response returns a result back
    to the client issuing the request

    .. attribute:: _rtu_frame_size

    Indicates the size of the modbus rtu response used for
        calculating how much to read.
    */

    let should_respond = true

    override init(transaction_id: Int, protocol_id: Int, unit_id: Int, skip_encode :Bool){
        // Proxy to the lower level initializer //
        
        super.init(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id, skip_encode: skip_encode)
        //ModbusPDU(transaction_id: transaction_id, protocol_id: protocol_id, unit_id: unit_id, skip_encode: skip_encode)
    }
}
/*
//---------------------------------------------------------------------------#
// Exception PDU's
//---------------------------------------------------------------------------#
class ModbusExceptions {
    /*
    An enumeration of the valid modbus exceptions
    */
    let IllegalFunction         = 0x01
    let IllegalAddress          = 0x02
    let IllegalValue            = 0x03
    let SlaveFailure            = 0x04
    let Acknowledge             = 0x05
    let SlaveBusy               = 0x06
    let MemoryParityError       = 0x08
    let GatewayPathUnavailable  = 0x0A
    let GatewayNoResponse       = 0x0B

    static func decode(cls, code){
        /* Given an error code, translate it to a
        string error name.

        :param code: The code number to translate
        */
        values = dict((v, k) for k, v in cls.__dict__.iteritems()
        if not k.startswith('__') and not callable(v))
        return values.get(code, None)
    }

class ExceptionResponse: ModbusResponse{
    /* Base class for a modbus exception PDU */
    let ExceptionOffset = 0x80
    let _rtu_frame_size = 5

    init(function_code, exception_code=None, **kwargs){
        /* Initializes the modbus exception response

        :param function_code: The function to build an exception response for
            :param exception_code: The specific modbus exception to return
        */
        ModbusResponse.__init__(self, **kwargs)
        self.original_code = function_code
        self.function_code = function_code | self.ExceptionOffset
        self.exception_code = exception_code
    }
    
    func encode(){
        /* Encodes a modbus exception response

        :returns: The encoded exception packet
        */
        return chr(self.exception_code)
    }
    
    func decode(data){
        /* Decodes a modbus exception response

        :param data: The packet data to decode
        */
        self.exception_code = ord(data[0])
    }
    
    func __str__(){
        /* Builds a representation of an exception response

        :returns: The string representation of an exception response
        */
        let message = ModbusExceptions.decode(self.exception_code)
        let parameters = (self.function_code, self.original_code, message)
        return "Exception Response\(parameters)"
    }
}

class IllegalFunctionRequest: ModbusRequest {
    /*
    Defines the Modbus slave exception type 'Illegal Function'
    This exception code is returned if the slave::

    - does not implement the function code **or**
    - is not in a state that allows it to process the function
    */
    let ErrorCode = 1

    init(self, function_code, **kwargs){
        /* Initializes a IllegalFunctionRequest

        :param function_code: The function we are erroring on
        */
        ModbusRequest.__init__(self, **kwargs)
        self.function_code = function_code
    }
    
    func decode(data){
        /* This is here so this failure will run correctly

        :param data: Not used
        */
        pass
    }
    
    func execute(context){
        /* Builds an illegal function request error response

        :param context: The current context for the message
        :returns: The error response packet
        */
        return ExceptionResponse(self.function_code, self.ErrorCode)
    }
}
//---------------------------------------------------------------------------#
// Exported symbols
//---------------------------------------------------------------------------#
let __all__ = [
"ModbusRequest", "ModbusResponse", "ModbusExceptions",
"ExceptionResponse", "IllegalFunctionRequest"
]*/
