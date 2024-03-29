//
//  Diag.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 
import Foundation

/** Generates diagnostic reports */
public class Diag : ClientSubCommand {
    
    var parent: IPFSBase?
    
    /** Generates a network diagnostics report */
    public func net() async throws -> String {
        let bytes = try await parent!.fetchBytes("diag/net?stream-channels=true")
        
        return String(bytes: bytes, encoding: String.Encoding.utf8)!
    }
    
    /* Prints out system diagnostic information. */
    public func sys() async throws -> String {
        let bytes = try await parent!.fetchBytes("diag/sys?stream-channels=true")
        
        return String(bytes: bytes, encoding: String.Encoding.utf8)!
    }
}
