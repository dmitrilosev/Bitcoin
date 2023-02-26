//
//  NetworkManager.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchAssets(with searchString: String?, ids: [String]?, limit: Int, offset: Int, completion: @escaping (Result<[Asset], Error>) -> Void) -> Cancellable
    func fetchAssetHistoryItems(with assetId: String, completion: @escaping (Result<AssetHistoryItems, Error>) -> Void) -> Cancellable
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
        
    private init() {}
    
    func url(with searchStringOrNil: String?, ids: [String]?, limit: Int = 100, offset: Int = 0) -> URL {
        let searchString = searchStringOrNil == nil ? "" : searchStringOrNil!
        
        let searchPath = !searchString.isEmpty ? "search=\(searchString)&" : ""
        let idsPath = ids != nil ? "ids=\(ids!.joined(separator: ","))&" : ""
        
        let urlString = "https://api.coincap.io/v2/assets?\(searchPath)\(idsPath)limit=\(limit)&offset=\(offset)"
        let url = URL(string: urlString)
        return url != nil ? url! : URL(string: "https://api.coincap.io/v2/assets")!
    }
    
    func fetchAssets(with searchString: String?, ids: [String]?, limit: Int = 100, offset: Int = 0, completion: @escaping (Result<[Asset], Error>) -> Void) -> Cancellable {
        let url = url(with: searchString, ids: ids, limit: limit, offset: offset)
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            var result: Result<[Asset], Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            guard let data = data else {
                result = .success([])
                return
            }
            
            do {
                let assetData = try JSONDecoder().decode(AssetData.self, from: data)
                let assets = assetData.data
                result = .success(assets)
            }
            catch let error {
                result = .failure(error)
            }
        }
            
        dataTask.resume()
        return dataTask
    }
    
    func fetchAssetHistoryItems(with assetId: String, completion: @escaping (Result<AssetHistoryItems, Error>) -> Void) -> Cancellable {
        let url = URL(string: "https://api.coincap.io/v2/assets/\(assetId)/history?interval=m1")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            var result: Result<AssetHistoryItems, Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            guard let data = data else {
                result = .success([])
                return
            }
            
            do {
                let assetHistoryItemData = try JSONDecoder().decode(AssetHistoryItemData.self, from: data)
                let assetHistoryItems = assetHistoryItemData.data
                result = .success(assetHistoryItems)
            }
            catch let error {
                result = .failure(error)
            }
        }
            
        dataTask.resume()
        return dataTask
    }
}
