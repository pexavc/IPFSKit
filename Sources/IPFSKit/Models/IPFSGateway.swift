//
//  IPFSGateway.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public protocol IPFSGateway  {
    var host: IPFSHost { get }
    var gateway: String { get }
}

public extension IPFSGateway {
    var id: String? {
        host.id
    }
    
    var secret: String? {
        host.secret
    }
    
    func url(for object: IPFSObject) -> URL? {
        guard let url = URL(string: gateway) else {
            return nil
        }
        
        guard let host = url.host else {
            GraniteLogger.info("[IPFSKit] Make sure your gateway url is properly set. (https:// included).")
            return nil
        }
        
        let urlString = "https://" + host + "/ipfs/" + (object.hashBase58String ?? "")
        
        return URL(string: urlString)
    }
}
