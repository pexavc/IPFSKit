//
//  Block.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

import Foundation

public class Block : ClientSubCommand {
    
    var parent: IPFSBase?
    
    public func get(_ hash: Multihash) async throws -> [UInt8] {
        try await  parent!.fetchBytes("block/get?stream-channels=true&arg=\(b58String(hash))")
    }                                                                
    
    public func put(_ data: [UInt8]) async throws -> MerkleNode {
        let bytes = data.withUnsafeBytes { $0.load(as: [UInt8].self) }
        let data2 = Data(bytes: bytes, count: data.count)
        
        return try await parent!.net.sendTo(parent!.baseUrl+"block/put?stream-channels=true", content: data2).map {
            result in
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: result, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] else {
                    throw IpfsApiError.jsonSerializationFailed
                }
                
                return try merkleNodeFromJson(json as AnyObject)
            } catch {
                GraniteLogger.info("Block Error:\(error)")
                return .init()
            }
        }
        .eraseToAnyPublisher()
        .async()
    }
    
    public func stat(_ hash: Multihash) async throws -> JsonType {
        
        try await parent!.fetchJson("block/stat?stream-channels=true&arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
    }
}
