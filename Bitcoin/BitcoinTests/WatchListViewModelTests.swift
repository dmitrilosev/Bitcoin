//
//  WatchListViewModelTests.swift
//  BitcoinTests
//
//  Created by Dmitri Losev on 26.02.2023.
//

import XCTest
@testable import Bitcoin

// mock
class DataManagerMock: DataManagerProtocol {
        
    static let sharedMock = DataManagerMock()
    
    private(set) var hasCalledSetIcon = false
    private(set) var hasCalledGetIcon = false
    private(set) var hasCalledAddWatchListAssetId = false
    private(set) var hasCalledGetWatchListAssetIds = false
    private(set) var hasCalledIsAssetIdAdded = false
    private(set) var hasCalledRemoveAssetId = false
    
    func setIcon(icon: Icon) {
        hasCalledSetIcon = true
    }
    
    func getIcon() -> Icon {
        hasCalledGetIcon = true
        return Icon(name: "", assetName: "")
    }
    
    func addWatchListAssetId(assetId: String) {
        hasCalledAddWatchListAssetId = true
    }
    
    func getWatchListAssetIds() -> [String] {
        hasCalledGetWatchListAssetIds = true
        return []
    }
    
    func isAssetIdAdded(assetId: String) -> Bool {
        hasCalledIsAssetIdAdded = true
        return true
    }
    
    func removeAssetId(assetId: String) {
        hasCalledRemoveAssetId = true
    }
}

final class WatchListViewModelTests: XCTestCase {

    var dataManager: DataManagerMock!
    var watchListViewModel: WatchListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        dataManager = DataManagerMock()
        watchListViewModel = WatchListViewModel()
    }

    override func tearDownWithError() throws {
        dataManager = nil
        watchListViewModel = nil
        
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        let dataManagerMock = DataManagerMock.sharedMock
        watchListViewModel.dataManager = dataManagerMock
        
        let asset1 = Asset(id: "1", rank: "1", symbol: "s1", name: "n1", supply: "17193925.0000000000000000", maxSupply: "21000000.0000000000000000", marketCapUsd: "119150835874.4699281625807300", volumeUsd24Hr: "2927959461.1750323310959460", priceUsd: "6929.8217756835584756", changePercent24Hr: "-0.8101417214350335", vwap24Hr: "7175.0663247679233209")
        
        watchListViewModel.addAssetViewModel(assetViewModel: AssetViewModel(asset: asset1))
        XCTAssertTrue(dataManagerMock.hasCalledAddWatchListAssetId)
        
        _ = watchListViewModel.getAssetIds()
        XCTAssertTrue(dataManagerMock.hasCalledGetWatchListAssetIds)
        
        _ = watchListViewModel.isAssetViewModelAdded(assetViewModel: AssetViewModel(asset: asset1))
        XCTAssertTrue(dataManagerMock.hasCalledIsAssetIdAdded)
        
        watchListViewModel.removeAssetViewModel(assetViewModel: AssetViewModel(asset: asset1))
        XCTAssertTrue(dataManagerMock.hasCalledRemoveAssetId)
    }
}
