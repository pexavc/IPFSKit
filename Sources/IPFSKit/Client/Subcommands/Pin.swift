//
//  Pin.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 


/** Pinning an object will ensure a local copy is not garbage collected. */
public class Pin : ClientSubCommand {
    
    var parent: IPFSBase?
    
    public func add(_ hash: Multihash) async throws -> [Multihash] {
        
        let result = try await parent!.fetchJson("pin/add?stream-channels=true&arg=\(b58String(hash))")
            .eraseToAnyPublisher()
            .async()
        
        
        guard let objects = result.object?["Pins"]?.array else {
            throw IpfsApiError.pinError("Pin.add error: No Pinned objects in JSON data.")
        }
        
        let multihashes = try objects.map { try fromB58String($0.string!) }
        
        return multihashes
    }
    
    /** List objects pinned to local storage */
    public func ls() async throws -> [Multihash : JsonType] {
        
        /// The default is .Recursive
        let result = try await self.ls(.Recursive)
        
        
        ///turn the result into a [Multihash : AnyObject]
        var multihashes: [Multihash : JsonType] = [:]
        if let hashes = result.object {
            for (k,v) in hashes {
                multihashes[try fromB58String(k)] = v
            }
        }
        
        return multihashes
    }
    
    public func ls(_ pinType: PinType) async throws -> JsonType {
        
        let result = try await parent!.fetchJson("pin/ls?stream-channels=true&t=" + pinType.rawValue)
            .eraseToAnyPublisher()
            .async()
        
        guard let object = result.object?[IpfsCmdString.Keys.rawValue] else {
            throw IpfsApiError.pinError("Pin.ls error: No Keys Dictionary in JSON data.")
        }
        
        return object
    }
    
    public func rm(_ hash: Multihash) async throws -> [Multihash] {
        try await self.rm(hash, recursive: true)
    }
    
    public func rm(_ hash: Multihash, recursive: Bool) async throws -> [Multihash] {
        
        let result = try await parent!.fetchJson("pin/rm?stream-channels=true&r=\(recursive)&arg=\(b58String(hash))")
            .eraseToAnyPublisher()
            .async()
        
        
        
        guard let object = result.object?["Pins"]?.array else {
            throw IpfsApiError.pinError("Pin.rm error: No Pinned objects in JSON data.")
        }
        
        let multihashes = try object.map { try fromB58String($0.string!) }
        
        return multihashes
    }
    
}
