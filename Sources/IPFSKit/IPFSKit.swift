//
//  IPFSKit.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public class IPFSKit {
    public static var gateway: IPFSGateway? {
        get {
            return _gateway
        }
        set {
            guard let newValue else { return }
            IPFS.shared = .init(newValue)
            _gateway = newValue
        }
    }
    static var _gateway: IPFSGateway? = nil
}
