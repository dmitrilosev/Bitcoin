//
//  AssetHistoryItem.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import Foundation

typealias AssetHistoryItems = [AssetHistoryItem]

struct AssetHistoryItem: Decodable {
    let priceUsd: String?
    let time: Date?
}

struct AssetHistoryItemData: Decodable {
    let data: [AssetHistoryItem]
    let timestamp: Date
}

