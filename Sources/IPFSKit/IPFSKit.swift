//
//  IPFSKit.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public class IPFSKit {
    public static var gateway: (any IPFSGateway)? {
        get {
            return _gateway
        }
        set {
            guard let newValue else { return }
            current = .init(newValue)
            _gateway = newValue
        }
    }
    static var _gateway: (any IPFSGateway)? = nil
    public static var current: IPFS?
}
