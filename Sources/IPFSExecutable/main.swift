//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import IPFSKit

struct InfuraGateway: IPFSGateway {
    var host: IPFSHost {
        InfuraHost(id: "...",//On Infura, this is simply the API_KEY
                   secret: "...")//API_KEY_SECRET
    }
    
    var gateway: String {
        "https://neatia.infura-ipfs.io"
    }
}

IPFSKit.gateway = InfuraGateway()

let data: Data = "Hello World".data(using: .utf8)!

let response = await IPFS.upload(data)

print(IPFSKit.gateway?.url(for: response))
