# IPFSKit

[![Swift 5.7](https://img.shields.io/badge/swift-5.7-brightgreen.svg)](https://github.com/apple/swift)
[![xcode-version](https://img.shields.io/badge/xcode-14.2-brightgreen)](https://developer.apple.com/xcode/)

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
```

### Adding data to IPFS

```swift

let data: Data = "Hello World".data(using: .utf8)!

let response = await IPFS.upload(data)

print(IPFSKit.gateway?.url(for: response))

```

Convert any type of object into a `Data` type to prepare for adding.

### Pinning data to IPFS

> Infura seems to have updated their services to automatically pin data that is added via the `/add` endpoint. This step is uncessary depending on the provider used or edge cases involved.

```swift

let data: Data = "Hello World".data(using: .utf8)!

let response = await IPFS.upload(data)

let gatewayHash = await IPFS.pin(response)
```
