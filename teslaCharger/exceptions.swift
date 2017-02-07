//
//  exceptions.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 02.02.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

/*
Pymodbus Exceptions
    --------------------
    
Custom exceptions to be used in the Modbus code.
*/


class ModbusException: Error {
    /* Base modbus exception */
    let string :String

    init (string: String){
        /* Initialize the exception

        :param string: The message to append to the error
        */
        self.string = string
    }
    func __str__() -> String {
        return "Modbus Error: \(self.string)"
    }
}


class ModbusIOException: ModbusException {
    /* Error resulting from data i/o */
    
    let message :String

    override init(string: String = ""){
        /* Initialize the exception

        :param string: The message to append to the error
        */
        message = "[Input/Output] \(string)"
        super.init(string: message)
    }
}

class ParameterException: ModbusException {
    /* Error resulting from invalid parameter */
    
    let message :String

    override init(string: String = ""){
        /* Initialize the exception

        :param string: The message to append to the error
        */
        message = "[Invalid Parameter] \(string)"
        super.init(string: message)
    }
}

class NoSuchSlaveException: ModbusException {
    /* Error resulting from making a request to a slave
     that does not exist */
    
    let message :String
    
    override init(string: String = ""){
        /* Initialize the exception
         
         :param string: The message to append to the error
         */
        message = "[No Such Slave] \(string)"
        super.init(string: message)
    }
}

class NotImplementedException: ModbusException {
    /* Error resulting from not implemented function */
    
    let message :String
    
    override init(string: String = ""){
        /* Initialize the exception
         
         :param string: The message to append to the error
         */
        message = "[Not Implemented] \(string)"
        super.init(string: message)
    }
}

class ConnectionException: ModbusException {
    /* Error resulting from a bad connection */
    
    let message :String
    
    override init(string: String = ""){
        /* Initialize the exception
         
         :param string: The message to append to the error
         */
        message = "[Connection] \(string)"
        super.init(string: message)
    }
}



//---------------------------------------------------------------------------#
// Exported symbols
//---------------------------------------------------------------------------#
/*var __all__ = [
"ModbusException", "ModbusIOException",
"ParameterException", "NotImplementedException",
"ConnectionException", "NoSuchSlaveException",
]*/
