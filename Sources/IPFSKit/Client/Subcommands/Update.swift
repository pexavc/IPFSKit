//
//  Update.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details.

public class Update : ClientSubCommand {
    
    var parent: IPFSBase?
    
    public func check() async throws -> JsonType {
        
        try await parent!.fetchJson("update/check")
            .eraseToAnyPublisher()
            .async()
    }
    
    public func log() async throws -> JsonType {
        
        try await parent!.fetchJson("update/log")
            .eraseToAnyPublisher()
            .async()
    }
}
