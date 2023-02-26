//
//  ImageManager.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import UIKit

protocol ImageManagerProtocol {
    func downloadImage(for symbol: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable
}

class ImageManager: ImageManagerProtocol {
    static let shared = ImageManager()
    private init() {}
    
    func url(for symbol: String) -> URL {
//        let urlString = "https://cryptoicons.org/api/color/" + symbol.lowercased() + "/600/a1a1a1" // API is down
        let urlString = "https://coinicons-api.vercel.app/api/icon/" + symbol.lowercased()
        return URL(string: urlString)!
    }
    
    func downloadImage(for symbol: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable {
        let url = url(for: symbol)
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            var result: Result<UIImage, Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
            }
            
            guard let data = data else {
                result = .success(UIImage())
                return
            }
            
            guard let image = UIImage(data: data) else {
                result = .success(UIImage())
                return
            }
            
            result = .success(image)
        }
        
        dataTask.resume()
        return dataTask
    }
}
