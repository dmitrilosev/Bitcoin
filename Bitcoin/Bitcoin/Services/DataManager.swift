//
//  DataManager.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import Foundation

protocol DataManagerProtocol {
    func setIcon(icon: Icon)
    func getIcon() -> Icon
    
    func addWatchListAssetId(assetId: String)
    func getWatchListAssetIds() -> [String]
    func isAssetIdAdded(assetId: String) -> Bool
    func removeAssetId(assetId: String)
}

class DataManager: DataManagerProtocol {
    
    static let shared = DataManager()
    
    static let iconNameKey = "iconName"
    static let iconAssetNameKey = "iconAssetName"
    static let watchListKey = "watchList"
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    func setIcon(icon: Icon) {
        userDefaults.set(icon.name, forKey: DataManager.iconNameKey)
        userDefaults.set(icon.assetName, forKey: DataManager.iconAssetNameKey)
    }
    
    func getIcon() -> Icon {
        let iconName = userDefaults.string(forKey: DataManager.iconNameKey)
        let iconAssetName = userDefaults.string(forKey: DataManager.iconAssetNameKey)
        if let iconName = iconName, let iconAssetName = iconAssetName {
            return Icon(name: iconName, assetName: iconAssetName)
        } else {
            return Icon.whiteIcon()
        }
    }
    
    func addWatchListAssetId(assetId: String) {
        var assetIds = getWatchListAssetIds()
        assetIds.insert(assetId, at: 0)
        userDefaults.set(assetIds, forKey: DataManager.watchListKey)
    }
    
    func getWatchListAssetIds() -> [String] {
        let assetIds = userDefaults.array(forKey: DataManager.watchListKey) as? [String]
        if let assetIds = assetIds {
            return assetIds
        } else {
            return [String]()
        }
    }
    
    func isAssetIdAdded(assetId: String) -> Bool {
        let assetIds = getWatchListAssetIds()
        let firstIndex = assetIds.firstIndex(of: assetId)
        return firstIndex != nil
    }
    
    func removeAssetId(assetId: String) {
        var assetIds = getWatchListAssetIds()
        let firstIndex = assetIds.firstIndex(of: assetId)
        if let firstIndex = firstIndex {
            assetIds.remove(at: firstIndex)
            userDefaults.set(assetIds, forKey: DataManager.watchListKey)
        }
    }
}
