//
//  Swarm.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

public class Swarm : ClientSubCommand {
    
    var parent: IPFSBase?
    
    /** Lists the set of peers this node is connected to.
        The completionHandler is passed an array of Multiaddr that represent the peers.
     */
    public func peers() async throws -> [Multiaddr] {
        let result = try await parent!.fetchJson("swarm/peers?stream-channels=true")
            .eraseToAnyPublisher()
            .async()
        
        var addresses: [Multiaddr] = []
        if let swarmPeers = result.object?[IpfsCmdString.Peers.rawValue]?.array {
            /// Make an array of Multiaddr from each peer in swarmPeers.
            addresses = try swarmPeers.map {
                guard let peer = $0.object?["Addr"]?.string else {  throw IpfsApiError.nilData }
                // Broken until multiaddr can deal with p2p-circuit multiaddr
                return try newMultiaddr(peer)
            }
        }
        
        /// convert the data into a Multiaddr array and pass it to the handler
        return addresses
    }
    
    /** lists all addresses this node is aware of. */
    public func addrs() async throws -> JsonType {
        
        let result = try await parent!.fetchJson("swarm/addrs?stream-channels=true")
            .eraseToAnyPublisher()
            .async()
        
        guard let addrsData = result.object?[IpfsCmdString.Addrs.rawValue] else {
            throw IpfsApiError.swarmError("Swarm.addrs error: No Addrs key in JSON data.")
        }
        
        return addrsData
    }
    
    /** opens a new direct connection to a peer address. */
    public func connect(_ multiaddr: String) async throws -> JsonType {
        try await parent!.fetchJson("swarm/connect?arg=" + multiaddr)
            .eraseToAnyPublisher()
            .async()
    }
    
    public func disconnect(_ multiaddr: String) async throws -> JsonType {
        try await parent!.fetchJson("swarm/disconnect?arg=" + multiaddr)
            .eraseToAnyPublisher()
            .async()
    }
}
