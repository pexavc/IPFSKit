//
//  IPFS.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation

public class IPFS {
    static var shared: IPFS? {
        IPFSKit.current
    }
    
    let client: IPFSClient?
    
    public var isReady: Bool {
        client != nil
    }
    
    init(_ gateway: any IPFSGateway) {
        client = try? .init(gateway)
    }
    
    public static func upload(_ data: Data) async -> IPFSObject {
        guard let shared else { return .init(state: .earlyFailure) }
        
        do {
            let nodes = try await shared.client?.add(data) ?? []
            return .init(nodes, state: .success)
        } catch let error {
            GraniteLogger.info("error adding data to ipfs network:\n\(error)", .expedition, focus: true)
        }
        
        return .init(state: .addFailed)
    }
    
    @discardableResult
    public static func pin(_ object: IPFSObject) async -> String? {
        guard let shared else { return nil }
        
        if let hash = object.hash {
            do {
                guard let pinHash = try await shared.client?.pin.add(hash).first else {
                    return nil
                }
                
                return b58String(pinHash)
                
            } catch let error {
                GraniteLogger.info("error pinning data to ipfs network:\n\(error)", .expedition, focus: true)
            }
        }
        
        return nil
    }
    
    public static func ipns() {
        guard let shared else { return }
    }
}

public enum IPFSUploadResponseState: String {
    case earlyFailure
    case unknown
    case success
    case addFailed
}
