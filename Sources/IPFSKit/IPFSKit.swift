//
//  File.swift
//  
//
//  Created by Ritesh Pakala on 7/11/23.
//

import Foundation

public class IPFSKit {
    
}

public protocol IPFSGateway  {
    var host: IPFSHost { get set }
    var ssl: Bool { get }
    var id: String { get }
    //API Key
    var secret: String { get }
}

public enum IPFSHost {
    case infura
    case custom(String)
    
    var hostUrl: String {
        switch self {
        case .infura:
            return "ipfs.infura.io"
        case .custom(let url):
            return url
        }
    }
}
