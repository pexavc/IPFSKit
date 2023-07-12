//
//  Bootstrap.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 


/**
 SECURITY WARNING:
 
 The bootstrap command manipulates the "bootstrap list", which contains
 the addresses of bootstrap nodes. These are the *trusted peers* from
 which to learn about other peers in the network. Only edit this list
 if you understand the risks of adding or removing nodes from this list.
 */
public class Bootstrap : ClientSubCommand {
    
    var parent: IPFSBase?
    
    
    public func list() async throws -> [Multiaddr] {
        try await fetchPeers("bootstrap/")
    }
    
    public func add(_ addresses: [Multiaddr]) async throws -> [Multiaddr] {
        
        let multiaddresses = try addresses.map { try $0.string() }
        let request = "bootstrap/add?" + buildArgString(multiaddresses)
        
        return try await fetchPeers(request)
    }
    
    public func rm(_ addresses: [Multiaddr]) async throws -> [Multiaddr] {
        
        return try await self.rm(addresses, all: false)
    }
    
    public func rm(_ addresses: [Multiaddr], all: Bool) async throws -> [Multiaddr] {
        
        let multiaddresses = try addresses.map { try $0.string() }
        var request = "bootstrap/rm?"
        
        if all { request += "all=true&" }
        
        request += buildArgString(multiaddresses)
        
        return try await fetchPeers(request)
    }
    
    private func fetchPeers(_ request: String) async throws -> [Multiaddr] {
                                                        
        let result = try await parent!.fetchJson(request)
            .eraseToAnyPublisher()
            .async()
        var addresses: [Multiaddr] = []
        if let peers = result.object?[IpfsCmdString.Peers.rawValue]?.array {
            /// Make an array of Multiaddr from each peer
            addresses = try peers.map { try newMultiaddr($0.string!) }
        }
            
        /// convert the data into a Multiaddr array and pass it to the handler
        return addresses
    }
}
