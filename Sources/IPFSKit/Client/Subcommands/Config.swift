//
//  Config.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

/** Config controls configuration variables. It works much like 'git config'.
 The configuration values are stored in a config file inside your IPFS repository.
 */
import Foundation
import Combine

public class Config : ClientSubCommand {
    
    var parent: IPFSBase?
    
    public func show() async throws -> JsonType {
        
        try await parent!.fetchJson("config/show")
            .eraseToAnyPublisher()
            .async()
    }
    
    public func replace(_ filePath: String) async throws -> Data {
        try await parent!.net.sendTo(parent!.baseUrl+"config/replace?stream-channels=true", filePath: filePath).map {
            result in
            return result
        }
        .eraseToAnyPublisher()
        .async()
    }
    
    public func get(_ key: String) async throws -> JsonType {
        let result = try await parent!.fetchJson("config?arg=" + key)
            .eraseToAnyPublisher()
            .async()
        
        guard let value = result.object?[IpfsCmdString.Value.rawValue] else {
            throw IpfsApiError.swarmError("Config get error: \(String(describing: result.object?[IpfsCmdString.Message.rawValue]?.string))")
        }
        
        return value
    }
    
    public func set(_ key: String, value: String) async throws -> JsonType {
        try await parent!.fetchJson("config?arg=\(key)&arg=\(value)")
            .eraseToAnyPublisher()
            .async()
    }
}
