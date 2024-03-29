//
//  Stats.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details.

public class Stats : ClientSubCommand {
    
    var parent: IPFSBase?
    
    /** Print ipfs bandwidth information. Currently ignores flags.*/
    public func bw( _ peer: String? = nil,
        proto: String? = nil,
        poll: Bool = false,
        interval: String? = nil) async throws -> JsonType {
            try await parent!.fetchJson("stats/bw")
            .eraseToAnyPublisher()
            .async()
    }
}
