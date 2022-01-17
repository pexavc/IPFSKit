# IPFSKit

![Travis CI Build](https://app.travis-ci.com/0xKala/IPFSKit.svg?branch=main)
[![Swift 5.3](https://img.shields.io/badge/swift-5.5-brightgreen.svg)](https://github.com/apple/swift)
[![xcode-version](https://img.shields.io/badge/xcode-12.5-brightgreen)](https://developer.apple.com/xcode/)

Based on: https://github.com/ipfs-shipyard/swift-ipfs-http-client
Converted into a standalone Swift Package.

## Installation

Add this repo link as a swift package to your XCode project.

## Requirements
    - iOS 12 or later
    - macOS BigSur or later

## Usage

```swift
import IPFSKit

let client: IPFSClient?
    
public init() {
    client = try? IPFSClient.init(host: "ipfs.infura.io", port: 5001, ssl: true)
}
```

### Adding data to IPFS

```swift
if let data = result.data.pngData() {
    do {
        try state.service.client?.add(data) { nodes in // Adding data to IPFS
            // use 'nodes' to pin content
        }
    } catch let error {
        GraniteLogger.info("error adding new image:\n\(error)", .expedition, focus: true)
    }
}

```

Convert any type of object into a `Data` type to prepare for adding.

### Pinning data to IPFS

```swift
do {
    if let addHash = nodes.first?.hash { // the `nodes` from the closure of the previous code example
        try client?.pin.add(addHash) { pinHash in
            let gatewayHash = b58String(pinHash) // IPFS public hash gateway for the pinned content
        }
    }
} catch let error {
    GraniteLogger.info("error pinning:\n\(error)", .expedition, focus: true)
}
```
