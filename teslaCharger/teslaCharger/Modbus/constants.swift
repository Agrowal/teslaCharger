//
//  constants.swift
//  teslaCharger
//
//  Created by Grzegorz Mickowski on 27.01.2017.
//  Copyright © 2017 Grzegorz Mickowski. All rights reserved.
//

import Foundation

final class Defaults {
     /* 
     A collection of modbus default values
     
     .. attribute:: Port
     
     The default modbus tcp server port (502)
     
     .. attribute:: Retries
     
     The default number of times a client should retry the given
     request before failing (3)
     
     .. attribute:: RetryOnEmpty
     
     A flag indicating if a transaction should be retried in the
     case that an empty response is received. This is useful for
     slow clients that may need more time to process a requst.
     
     .. attribute:: Timeout
     
     The default amount of time a client should wait for a request
     to be processed (3 seconds)
     
     .. attribute:: Reconnects
     
     The default number of times a client should attempt to reconnect
     before deciding the server is down (0)
     
     .. attribute:: TransactionId
     
     The starting transaction identifier number (0)
     
     .. attribute:: ProtocolId
     
     The modbus protocol id.  Currently this is set to 0 in all
     but proprietary implementations.
     
     .. attribute:: UnitId
     
     The modbus slave addrss.  Currently this is set to 0x00 which
     means this request should be broadcast to all the slave devices
     (really means that all the devices should respons).
     
     .. attribute:: Baudrate
     
     The speed at which the data is transmitted over the serial line.
     This defaults to 19200.
     
     .. attribute:: Parity
     
     The type of checksum to use to verify data integrity. This can be
     on of the following::
     
     - (E)ven - 1 0 1 0 | P(0)
     - (O)dd  - 1 0 1 0 | P(1)
     - (N)one - 1 0 1 0 | no parity
     
     This defaults to (N)one.
     
     .. attribute:: Bytesize
     
     The number of bits in a byte of serial data.  This can be one of
     5, 6, 7, or 8. This defaults to 8.
     
     .. attribute:: Stopbits
     
     The number of bits sent after each character in a message to
     indicate the end of the byte.  This defaults to 1.
     
     .. attribute:: ZeroMode
     
     Indicates if the slave datastore should use indexing at 0 or 1.
     More about this can be read in section 4.4 of the modbus specification.
     
     .. attribute:: IgnoreMissingSlaves
     
     In case a request is made to a missing slave, this defines if an error
     should be returned or simply ignored. This is useful for the case of a
     serial server emulater where a request to a non-existant slave on a bus
     will never respond. The client in this case will simply timeout.
     */
    
    static let shared = Defaults()
    private init() {}
    
    let Port                = 502
    let Retries             = 3
    let RetryOnEmpty        = false
    let Timeout             = 3
    let Reconnects          = 0
    let TransactionId       = 0
    let ProtocolId          = 0
    let UnitId              = 0x00
    let Baudrate            = 19200
    let Parity              = "N"
    let Bytesize            = 8
    let Stopbits            = 1
    let ZeroMode            = false
    let IgnoreMissingSlaves = false
}

final class ModbusStatus {
    
    static let shared = ModbusStatus()
    private init() {}
    
     /*
     These represent various status codes in the modbus
     protocol.
     
     .. attribute:: Waiting
     
     This indicates that a modbus device is currently
     waiting for a given request to finish some running task.
     
     .. attribute:: Ready
     
     This indicates that a modbus device is currently
     free to perform the next request task.
     
     .. attribute:: On
     
     This indicates that the given modbus entity is on
     
     .. attribute:: Off
     
     This indicates that the given modbus entity is off
     
     .. attribute:: SlaveOn
     
     This indicates that the given modbus slave is running
     
     .. attribute:: SlaveOff
     
     This indicates that the given modbus slave is not running
     */
    
    let Waiting  = 0xffff
    let Ready    = 0x0000
    let On       = 0xff00
    let Off      = 0x0000
    let SlaveOn  = 0xff
    let SlaveOff = 0x00
}