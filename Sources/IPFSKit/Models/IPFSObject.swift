//
//  IPFSObject.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public struct IPFSObject {
    public var nodes: [MerkleNode]
    public var hash: Multihash?
    
    public var hashString: String? {
        hash?.string()
    }
    
    public var hashBase58String: String? = nil
    
    public var uploadState: IPFSUploadResponseState
    
    public init(_ nodes: [MerkleNode], state: IPFSUploadResponseState = .unknown) {
        self.nodes = nodes
        self.hash = nodes.first?.hash
        self.uploadState = state
        
        if let hash {
            hashBase58String = b58String(hash)
        }
    }
    
    public init(state: IPFSUploadResponseState) {
        self.nodes = []
        self.hash = nil
        self.uploadState = state
    }
    
    public static var empty: IPFSObject {
        .init([], state: .unknown)
    }
}

public extension IPFSObject {
    func pin() async {
        await IPFS.pin(self)
    }
}

public extension IPFSObject {
    //Readable helper
    var pinHash: String? {
        hashBase58String
    }
}
