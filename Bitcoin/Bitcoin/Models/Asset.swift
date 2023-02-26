//
//  Asset.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import Foundation

typealias Assets = [Asset]

struct Asset: Decodable {
    let id: String
    let rank: String?
    let symbol: String?
    let name: String?
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let vwap24Hr: String?
    
    static func getAsset() -> Asset {
        Asset(id: "bitcoin", rank: "1", symbol: "BTC", name: "Bitcoin", supply: "17193925.0000000000000000", maxSupply: "21000000.0000000000000000", marketCapUsd: "119150835874.4699281625807300", volumeUsd24Hr: "2927959461.1750323310959460", priceUsd: "6929.8217756835584756", changePercent24Hr: "-0.8101417214350335", vwap24Hr: "7175.0663247679233209")
    }
}

struct AssetData: Decodable {
    let data: [Asset]
    let timestamp: Date
    
    static func getAssetData() -> AssetData {
        AssetData(data: [Asset.getAsset()], timestamp: Date())
    }
}
