//
//  AssetsViewModelViewModel.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import Foundation

protocol AssetsViewModelProtocol {
    var assetViewModels: [AssetViewModel] { get }
    func fetchAssets(with searchString: String?, ids: [String]?, limit: Int, offset: Int)
}

class AssetsViewModel: AssetsViewModelProtocol {
    var reloadTableView: (() -> Void)?
    
    var assetViewModels = [AssetViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var error: Error? = nil
    
    internal var fetchTask: Cancellable?
    
    func fetchAssets(with searchString: String?, ids: [String]?, limit: Int = 100, offset: Int = 0) {
        fetchTask?.cancel()
        fetchTask = NetworkManager.shared.fetchAssets(with: searchString, ids: ids, limit: limit, offset: offset) { [weak self] result in
            switch result {
            case .success(let assets):
                self?.assetViewModels = assets.map { AssetViewModel(asset: $0) }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
