//
//  main.swift
//  
//
//  Created by PEXAVC on 7/11/23.
//

import Foundation
import IPFSKit
import CryptoKit

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

var data: Data = "Hello World".data(using: .utf8)!
//data += Data(count: max(16 - data.count, 0))
var sha = SHA256.hash(data: data)
let mh = Data([0x12, 0x20]) + sha

let bytes = [UInt8](mh)
let bytes2 = [UInt8]("Hello World".utf8)

let s = ipfsHash(s: "Hello World")
print(s)
let hash = try! fromHexString(ipfsHash(s: "Hello World"))//Multihash(try! encodeBuf(bytes, code: 0x12))
print(b58String(hash))

let fromhash = try! fromB58String("QmUXTtySmd7LD4p6RG6rZW6RuUuPZXTtNMmRQ6DSQo3aMw")


//print(fromhash.value)
let dec = try! decodeBuf(fromhash.value)
//print(dec.length)
//print(0x12)
print(bytes)
//print(bytes2)
print(fromhash.value)
print(dec.digest)
print(dec.name)
func ipfsHash(s: String) -> String {
    let ints = s.unicodeScalars.map { $0.value }

    // Compute the mean and standard deviation of the sequence
    let mean = Double(ints.reduce(0, +)) / Double(ints.count)
    let stddev = (ints.map { pow(Double($0) - mean, 2) }.reduce(0, +) / Double(ints.count)).squareRoot()

    // Concatenate binary values
    let binary = UInt8(mean) << 8 | UInt8(stddev)

    // Multihash prefix for SHA-256: 0x12 0x20
    let prefix = Data([0x12, 0x20])

    // Hash concatenated binary string with SHA-256
    let hash = SHA256.hash(data: [binary])

    return (prefix + hash)
        .withUnsafeBytes {
            Array($0).suffix(32)
        }
        .reduce(into: "") {
            $0 += String(format: "%02x", $1)
        }
}

public struct Multihash2 {

    let code: UInt8
    let digest: Data

    var length: Int {
        return digest.count
    }

    var bytes: Data {
        var data = Data(repeating: 0, count: 0)
        data.append(contentsOf: [code, UInt8(length)])
        data.append(digest)
        return data
    }

    init(code: UInt8, hash: Data) {
        self.code = code
        self.digest = hash
    }

    func toBase58() -> String? {
        return Granite58.encode([UInt8](bytes))
    }
}

extension Multihash2 {

    // @todo error handling
    init?(base58 input: String) {
        let buffer = Granite58.decode(input)

        if buffer.count < 2 {
            return nil
        }

        let hash = Data(buffer[2...(1+Int(buffer[1]))])

        self.init(code: buffer[0], hash: hash)
    }
}

