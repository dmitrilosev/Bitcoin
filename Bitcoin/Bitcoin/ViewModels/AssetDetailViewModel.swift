//
//  AssetDetailViewModel.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import Foundation

protocol AssetDetailViewModelProtocol {
    var name: String { get }
    var value: String { get }
}

class AssetDetailViewModel: AssetDetailViewModelProtocol {
    var name: String
    var value: String
    static let localeIdentifier = "en_US"
    
    var formattedValue: String {
        guard let doubleValue = Double(value) else { return "" }
        return currencyFormatter.string(from: NSNumber(value: doubleValue))!
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: AssetDetailViewModel.localeIdentifier)
        return formatter
    }()
}
