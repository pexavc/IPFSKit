//
//  IPFSHost.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public protocol IPFSHost {
    var url: String { get }
    var port: Int { get set }
    var ssl: Bool { get }
    //api endpoint version, appended to url
    var version: String { get }
    var id: String? { get set }
    var secret: String? { get set }
}

// MARK: -- Known Gateways, Pre-defined

public struct InfuraHost: IPFSHost {
    public var url: String {
        "ipfs.infura.io"
    }
    
    public var port: Int
    
    public var ssl: Bool { true }
    
    public var version: String {
        "/api/v0/"
    }
    
    public var id: String?
    public var secret: String?
    
    public init(port: Int = 5001,
                id: String,
                secret: String) {
        self.port = port
        self.id = id
        self.secret = secret
    }
}
