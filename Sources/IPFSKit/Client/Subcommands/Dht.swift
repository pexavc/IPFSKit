//
//  Dht.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

import Foundation

public class Dht : ClientSubCommand {
    
    var parent: IPFSBase?
    
    /** FindProviders will return a list of peers who are able to provide the value requested. */
//    public func findProvs(_ hash: Multihash, numProviders: Int = 20, completionHandler: @escaping (JsonType) -> Void) throws {
//        try parent!.fetchJson("dht/findprovs?arg=\(b58String(hash))&num-providers=\(numProviders)", completionHandler: completionHandler)
//    }
    public func findProvs(_ hash: Multihash, numProviders: Int = 20, completionHandler: @escaping (JsonType) -> Void) throws {
        /// Two test closures to be passed to the fetchStreamJson as parameters.
        let comp = { (result: AnyObject) -> Void in
            GraniteLogger.info("Job done")
        }
        
        let update : ((Data, URLSessionDataTask) -> Bool) = { (data: Data, task: URLSessionDataTask) -> Bool in

            func getHash(from obj: [String : JsonType], forResponse type: Int) -> [String]? {
                
                if obj["Type"]?.number?.intValue == type {
                    if let responses = obj["Responses"]?.array {
                        // only keep the responses that contain an ID.
                        return responses.compactMap { $0.object?["ID"]?.string }
                    }
                }
                return nil
            }
            

            GraniteLogger.info("updates")
            let fixed = fixStreamJson(data)
            let json = try? JSONSerialization.jsonObject(with: fixed, options: JSONSerialization.ReadingOptions.allowFragments)
            let parsedJ = JsonType.parse(json as AnyObject)
            
            var providers = [JsonType]()
            // A valid response can either be an array of objects or an object.
            switch parsedJ {
            case JsonType.Array(let array):
//                GraniteLogger.info("we iz got de arrays")
                providers += array.filter { $0.object?["Type"]?.number == 4 }
//                for obj in array {
//                    if let jobj = obj.object, jobj["Type"]?.number == 4 {
//                            providers += jobj
//                    }
//                }
            case JsonType.Object(let obj):
//                GraniteLogger.info("we iz got de hobj innit? \(obj)")
                if obj["Type"]?.number == 4 {
                    providers.append(parsedJ)
                }
//                if let provs = getHash(from: obj, forResponse: 4) {
//                    providers += provs
//                }
                
            default:
                GraniteLogger.info("fukkal")
            }
            
            
            if providers.count >= numProviders {
                GraniteLogger.info("We found these providers \(providers)")
                let provs = JsonType.parse(providers as AnyObject)
                completionHandler(provs)
                
            }

//            guard let jarray = parsedJ.array else {
//                GraniteLogger.info("No array in parsed json update \(parsedJ)")
//                return true
//            }
//
//            for obj in jarray {
//                GraniteLogger.info("json: \(String(describing: obj.object?["Type"]))")
//            }
            
//            GraniteLogger.info("json: \(json)")
//
//            if let arr = json as? [AnyObject] {
//                for res in arr {
//                    GraniteLogger.info(res)
//                }
//            } else {
//                if let dict = json as? [String: AnyObject] {
//                    GraniteLogger.info("It's a dict!:",dict )
//                }
//            }
            return true
        }
        
        try parent!.fetchStreamJson("dht/findprovs?arg=\(b58String(hash))&num-providers=\(numProviders)", updateHandler: update, completionHandler: comp)
    }
   
    /** Run a 'findClosestPeers' query through the DHT */
    public func query(_ hash: Multihash) async throws -> JsonType {
        try await parent!.fetchJson("dht/query?arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
    }
    
    /** Run a 'FindPeer' query through the DHT */
    public func findpeer(_ hash: Multihash) async throws -> JsonType {
        try await parent!.fetchJson("dht/findpeer?arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
    }
    
    /** Will return the value stored in the dht at the given key */
    public func get(_ hash: Multihash) async throws -> JsonType {
        try await parent!.fetchJson("dht/get?arg=" + b58String(hash))
            .eraseToAnyPublisher()
            .async()
    }
    
    /** Will store the given key value pair in the dht. */
    public func put(_ key: String, value: String) async throws -> JsonType {
        try await parent!
                    .fetchJson("dht/put?arg=\(key)&arg=\(value)")
                    .eraseToAnyPublisher()
                    .async()
    }
}
