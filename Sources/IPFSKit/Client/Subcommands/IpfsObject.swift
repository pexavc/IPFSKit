//
//  IpfsObject.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

import Foundation

public class IpfsObject : ClientSubCommand {
    
    var parent: IPFSBase?
    
    public enum ObjectTemplates: String {
        case UnixFsDir = "unixfs-dir"
    }
    
    public enum ObjectPatchCommand: String {
        case AddLink    = "add-link"
        case RmLink     = "rm-link"
        case SetData    = "set-data"
        case AppendData = "append-data"
    }
    
    /**
     IpfsObject new is a plumbing command for creating new DAG nodes.
     By default it creates and returns a new empty merkledag node, but
     you may pass an optional template argument to create a preformatted
     node.
     
     Available templates:
    	* unixfs-dir
     */
    public func new(_ template: ObjectTemplates? = nil) async throws -> MerkleNode {
        var request = "object/new?stream-channels=true"
        if template != nil { request += "&arg=\(template!.rawValue)" }
        let result = try await parent!.fetchJson(request)
            .eraseToAnyPublisher()
            .async()
        return try merkleNodeFromJson2(result)
    }
    
    /** IpfsObject put is a plumbing command for storing DAG nodes.
     Its input is a byte array, and the output is a base58 encoded multihash.
     */
    public func put(_ data: [UInt8]) async throws -> MerkleNode {
        let bytes = data.withUnsafeBytes { $0.load(as: [UInt8].self) }
        
        let data2 = Data(bytes: bytes, count: data.count)
        
        return try await parent!.net.sendTo(parent!.baseUrl+"object/put?stream-channels=true", content: data2).map {
            result in
            
            do {
                GraniteLogger.info(result)
                guard let json = try JSONSerialization.jsonObject(with: result, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] else {
                    throw IpfsApiError.jsonSerializationFailed
                }
                
                return try merkleNodeFromJson(json as AnyObject)
            } catch {
                GraniteLogger.info("IpfsObject Error:\(error)")
                return .init()
            }
        }
        .eraseToAnyPublisher()
        .async()
    }
    
    /** IpfsObject get is a plumbing command for retreiving DAG nodes.
     Its input is a base58 encoded Multihash and it returns a MerkleNode.
     */
    public func get(_ hash: Multihash) async throws -> MerkleNode {
        
        let result = try await parent!.fetchJson("object/get?stream-channels=true&arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
        
        guard var res = result.object else { throw IpfsApiError.resultMissingData("No object found!")}
        res["Hash"] = .String(b58String(hash))
        
        return try merkleNodeFromJson2(.Object(res))
    }
    
    public func links(_ hash: Multihash) async throws -> MerkleNode {
        
        let result = try await parent!.fetchJson("object/links?stream-channels=true&arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
        
        return try merkleNodeFromJson2(result)
    }
    
    public func stat(_ hash: Multihash) async throws -> JsonType {
        
        try await parent!.fetchJson("object/stat?stream-channels=true&arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
    }
    
    public func data(_ hash: Multihash) async throws -> [UInt8] {
        
        try await parent!.fetchBytes("object/data?stream-channels=true&arg=" + b58String(hash))
    }
    
//    public func patch(_ root: Multihash, cmd: ObjectPatchCommand, args: String..., completionHandler: @escaping (MerkleNode) throws -> Void) throws {
//
//        var request: String = "object/patch?arg=\(b58String(root))&arg=\(cmd.rawValue)&"
//
//        if cmd == .AddLink && args.count != 2 {
//            throw IpfsApiError.ipfsObjectError("Wrong number of arguments to \(cmd.rawValue)")
//        }
//
//        request += buildArgString(args)
//
//        try parent!.fetchJson(request) {
//            result in
//            try completionHandler(try merkleNodeFromJson2(result))
//        }
//    }
    // change root to String ?
    public func patch(_ root: Multihash, cmd: ObjectPatchCommand, args: String...) async throws -> MerkleNode {
        
        var request: String = "object/patch"
        switch cmd {
        case .AddLink:
            GraniteLogger.info("patch add link")
            guard args.count == 2 else {
                throw IpfsApiError.ipfsObjectError("Wrong number of arguments to \(cmd.rawValue)")
            }
            request += "/add-link"
        case .RmLink:
            GraniteLogger.info("patch remove link")
            request += "/rm-link"
        case .SetData:
            GraniteLogger.info("patch set data")
            request += "/set-data"
        case .AppendData:
            GraniteLogger.info("patch append data")
            request += "/append-data"
        }
        
        request += "?arg=\(b58String(root))&"
        
        request += buildArgString(args)
        
        let result = try await parent!.fetchJson(request)
            .eraseToAnyPublisher()
            .async()
        
        return try merkleNodeFromJson2(result)
    }
}
