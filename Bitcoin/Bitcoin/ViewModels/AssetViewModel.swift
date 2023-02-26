//
//  AssetViewModel.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import UIKit

protocol AssetViewModelProtocol {
    var id: String { get }
    var name: String { get }
    var symbol: String { get }
    var priceUsd: String { get }
    var changePercent24Hr: String { get }
    var marketCapUsd: String { get }
    var supply: String { get }
    var volumeUsd24Hr: String { get }
    
    var image: UIImage? { get }
    var imageTask: Cancellable? { get }
    
    init(asset: Asset)
    
    func downloadImage()
    func cancelDownloadingImage()
    
    var assetHistoryItems: [AssetHistoryItem] { get }
    func fetchAssetHistoryItems(with assetId: String)
}

class AssetViewModel: AssetViewModelProtocol {
    private let asset: Asset
    static let localeIdentifier = "en_US"
    
    var id: String {
        asset.id
    }
    
    var name: String {
        asset.name ?? ""
    }
    
    var symbol: String {
        asset.symbol ?? ""
    }
    
    var priceUsd: String {
        guard let price = asset.priceUsd else { return "" }
        guard let value = Double(price) else { return "" }
        return currencyFormatter.string(from: NSNumber(value: value))!
    }
    
    var changePercent24Hr: String {
        guard let price = asset.changePercent24Hr else { return "" }
        guard let value = Double(price) else { return "" }
        return percentFormatter.string(from: NSNumber(value: value/100))!
    }
    
    var marketCapUsd: String {
        asset.marketCapUsd ?? ""
    }
    
    var supply: String {
        asset.supply ?? ""
    }
    
    var volumeUsd24Hr: String {
        asset.volumeUsd24Hr ?? ""
    }
    
    required init(asset: Asset) {
        self.asset = asset
    }
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: AssetViewModel.localeIdentifier)
        return formatter
    }()
    
    let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.positivePrefix = "+"
        formatter.locale = Locale(identifier: AssetViewModel.localeIdentifier)
        return formatter
    }()
    
    // MARK: - Image Downloading
    
    var reloadImageView: (() -> Void)?
    
    var image: UIImage? {
        didSet {
            reloadImageView?()
        }
    }
    
    internal var imageTask: Cancellable?
    
    func downloadImage() {
        imageTask = ImageManager.shared.downloadImage(for: symbol, completion: { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func cancelDownloadingImage() {
        imageTask?.cancel()
    }
    
    // MARK: - Asset History
    var reloadTableView: (() -> Void)?
    
    var assetHistoryItems = [AssetHistoryItem]() {
        didSet {
            reloadTableView?()
        }
    }
    
    internal var fetchAssetHistoryItemsTask: Cancellable?
    
    func fetchAssetHistoryItems(with assetId: String) {
        fetchAssetHistoryItemsTask?.cancel()
        fetchAssetHistoryItemsTask = NetworkManager.shared.fetchAssetHistoryItems(with: assetId, completion: { [weak self] result in
            switch result {
            case .success(let assetHistoryItems):
                self?.assetHistoryItems = assetHistoryItems
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
