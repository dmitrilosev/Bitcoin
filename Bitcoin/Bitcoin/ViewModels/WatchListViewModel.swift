//
//  WatchListViewModel.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import Foundation

protocol WatchListViewModelProtocol {
    var dataManager: DataManagerProtocol { get }
    
    func addAssetViewModel(assetViewModel: AssetViewModel)
    func isAssetViewModelAdded(assetViewModel: AssetViewModel) -> Bool
    func removeAssetViewModel(assetViewModel: AssetViewModel)
    func getAssetIds() -> [String]
}

class WatchListViewModel: WatchListViewModelProtocol {
    var dataManager: DataManagerProtocol = DataManager.shared
    
    func addAssetViewModel(assetViewModel: AssetViewModel) {
        dataManager.addWatchListAssetId(assetId: assetViewModel.id)
    }
    
    func isAssetViewModelAdded(assetViewModel: AssetViewModel) -> Bool {
        return dataManager.isAssetIdAdded(assetId: assetViewModel.id)
    }
    
    func removeAssetViewModel(assetViewModel: AssetViewModel) {
        dataManager.removeAssetId(assetId: assetViewModel.id)
    }
    
    func getAssetIds() -> [String] {
        dataManager.getWatchListAssetIds()
    }
}
